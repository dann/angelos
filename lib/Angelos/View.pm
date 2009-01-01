package Angelos::View;
use Mouse;
use Angelos::Home;
use Angelos::MIMETypes;
use Path::Class qw(file dir);
use Carp ();
use Angelos::Exceptions;

with( 'Angelos::Component', );

has _mixin_app_ns => ( +default => sub { ['Angelos::View'] }, );

has 'context' => ( is => 'rw', );

has 'types' => (
    is      => 'rw',
    default => sub {
        Angelos::MIMETypes->new;
    }
);

has 'root' => (
    is      => 'rw',
    default => sub {
        Angelos::Home->path_to( 'share', 'root', 'templates' );
    },
);

has 'CONTENT_TYPE' => (
    is      => 'rw',
    default => 'text/html',
);

has 'TEMPLATE_EXTENSION' => (
    is       => 'rw',
    required => 1,
);

around 'new' => sub {
    my ( $next, $class, @args ) = @_;
    my $instance = $next->( $class, @args );
    $instance->run_hook('AFTER_VIEW_INIT');
    $instance;
};

around 'render' => sub {
    my ( $next, $self, $args ) = @_;
    $self->run_hook( 'BEFORE_RENDER', $self->context );
    my $result = $self->$next($args);
    $self->run_hook( 'AFTER_RENDER', $self->context );
    return $result;
};

no Mouse;

sub render {
    my ( $self, $args ) = @_;
    my $c             = $self->context;
    my $template      = $self->_template($c);
    my $template_path = $self->_template_path($c);
    return undef unless $template || $template_path;

    $self->_build_stash($c);
    my $vars   = $self->_build_template_vars( $c, $args );
    my $output = $self->_do_render( $c,           $vars );
    return undef unless $output;

    $self->_build_response( $c, $output );
    return 1;
}

sub _build_template_vars {
    my ( $self, $c, $args ) = @_;
    my $vars = {
        ( ref $args eq 'HASH' ? %$args : %{ $c->stash() } ),
        $self->_template_vars($c)
    };
}

sub _template_vars {
    my ( $self, $c ) = @_;
    (   c    => $c,
        base => $c->req->base,
    );
}

sub _build_stash {
    my ( $self, $c ) = @_;
    $c->stash->{C} = $self->context;
    $c->stash->{base} ||= $c->req->base;
}

sub _do_render {
    my ( $self, $c, $vars ) = @_;
    my $output = eval { $self->_render( $c, $vars ); };
    $output;
}

sub _render {
    Angelos::Exception::AbstractMethod->throw(
        'Sub class must overried this method');
}

sub _build_response {
    my ( $self, $c, $output ) = @_;

    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);

    unless ( $c->res->content_type ) {
        # guess extension from request path
        my $ct = $self->CONTENT_TYPE
            || $self->_content_type( $c->stash->{format} || 'html' );

        # FIXME:
        my $charset = 'utf-8';
        $c->response->content_type("$ct; charset=$charset");
    }
    $c->res;
}

sub _template {
    my ( $self, $c ) = @_;
    my $template ||= $c->stash->{template};

    $template
        ||= lc($c->_match->params->{controller}) . "/"
        . $c->_match->params->{action}
        . $self->TEMPLATE_EXTENSION;

    # FIXME
    $c->stash->{template} = $template;
    $template;
}

sub _template_path {
    my ( $self, $c ) = @_;
    my $template      = $c->stash->{template};
    my $template_path = $c->stash->{template_path};

    # FIXME guess template pass via action if template_path isn't specified
    # get  $c->_match->params->{format}
    if ( $template && !$template_path ) {
        my $path = file( $self->root, $template );
        $c->stash->{template_path} = $path;
    }
    $c->stash->{template_path};
}

sub _content_type {
    my ( $self, $format ) = @_;
    $self->types->mime_type_of($format) || 'text/plain';
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

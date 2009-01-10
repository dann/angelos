package Angelos::View;
use Mouse;
use Angelos::Home;
use Angelos::MIMETypes;
use Path::Class qw(file dir);
use Angelos::Exceptions;

with( 'Angelos::Component', );

has _plugin_app_ns => ( +default => sub { ['Angelos::View'] }, );

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
    is  => 'rw',
    isa => 'Str',
);

has 'TEMPLATE_EXTENSION' => (
    is       => 'rw',
    required => 1,
);

has 'engine' => ( is => 'rw', );

sub BUILD {
    my $self            = shift;
    my $template_engine = $self->_build_engine;
    $self->engine($template_engine) if $template_engine;
}

no Mouse;

sub SETUP { }

sub render {
    my ( $self, $args ) = @_;
    $self->RENDER($args);
}

sub RENDER {
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
        message => 'Sub class must overried this method' );
}

sub _build_engine {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must overried this method' );
}

sub _build_response {
    my ( $self, $c, $output ) = @_;

    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);

    unless ( $c->res->content_type ) {

        # guess extension from request path
        my $ct
            = $self->_content_type( $c->stash->{format}
                || $c->_match->params->{format}
                || 'html' );
        my $charset = 'utf-8';
        $c->res->content_type("$ct; charset=$charset");
    }
    $c->res;
}

sub _template {
    my ( $self, $c ) = @_;
    my $template ||= $c->stash->{template};

    $template
        ||= lc( $c->_match->params->{controller} ) . "/"
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
    if ( $template && !$template_path ) {
        my $path = file( $self->root, $template );
        $c->stash->{template_path} = $path;
    }
    $c->stash->{template_path};
}

sub _content_type {
    my ( $self, $format ) = @_;
    return $self->CONTENT_TYPE if $self->CONTENT_TYPE;
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

package Angelos::View;
use Angelos::Class;
use Angelos::Home;
use Angelos::MIMETypes;
use Path::Class qw(file dir);
use Angelos::Exceptions;
use Params::Validate qw(SCALAR);

with 'Angelos::Component';
with 'Angelos::Class::HomeAware';

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
        my $self = shift;
        $self->home->path_to( 'share', 'root', 'templates' );
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

sub SETUP { }

# format
# -A registered mime-type format
# template
# The path to the template relative to the template root
# tatus
#   The status to send to the client. Typically, this would be an integer
#  (200), or a Merb status code (Accepted)
# params
#   template parameters
sub render {
    my $self   = shift;
    my %params = Params::Validate::validate(
        @_,
        {   template => { optional => 1 },
            format   => { optional => 1 },
            status   => { optional => 1 },
            params   => { optional => 1 },
        },
    );
    $self->RENDER( \%params );
}

sub RENDER {
    my ( $self, $opts ) = @_;
    my $c             = $self->context;
    my $template      = $self->_template( $c, $opts->{template} );
    my $template_path = $self->_template_path( $c, $opts->{template} );
    return undef unless $template || $template_path;

    $self->_build_stash($c);
    my $vars   = $self->_build_template_vars( $c, $opts->{params} );
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
    $c->stash->{c} = $self->context;
    $c->stash->{base} ||= $c->req->base;
}

sub _do_render {
    my ( $self, $c, $vars ) = @_;
    my $output = $self->_render( $c, $vars );
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
    my ( $self, $c, $given_template ) = @_;
    my $template ||= $given_template;
    $template
        ||= lc( $c->_match->params->{controller} ) . "/"
        . $c->_match->params->{action}
        . $self->TEMPLATE_EXTENSION;
    $c->stash->{template} = $template;
    $template;
}

sub _template_path {
    my ( $self, $c, $given_template ) = @_;
    my $template ||= $given_template;
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
    $self->types->mime_type_of($format);
}

__END_OF_CLASS__

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

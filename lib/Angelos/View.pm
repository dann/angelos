package Angelos::View;
use Moose;
use Angelos::Home;
use Angelos::MIMETypes;

with 'Angelos::Component';

has 'engine' => (
    is  => 'rw',
    isa => 'Angelos::View::Engine',
);

has 'types' => (
    is      => 'rw',
    default => sub {
        Angelos::MIMETypes->new;
    }
);

has 'format' => (
    is      => 'rw',
    default => sub {
        'tt';
    }
);

has 'root' => (
    is      => 'rw',
    default => sub {
        Angelos::Home->path_to( 'root', 'templates' );
    },
);

# FIXME config

no Moose;

sub render {
    my ( $self, $c, $args ) = @_;
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
        name => $c->config->{name}
    );
}

sub _build_stash {
    my ( $self, $c ) = @_;
    $c->stash->{C} = $self->context;
    $c->stash->{base} ||= $c->req->base;
}

sub _do_render {
    my ( $self, $c, $vars ) = @_;
    my $output = $self->engine->render( $c, $vars );
    $output;
}

sub _build_response {
    my ( $self, $c, $output ) = @_;

    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);
    my $type = $self->_format($c);

    unless ( $c->res->content_type ) {
        my $ct      = $self->_content_type( $c->stash->{format} );
        my $charset = 'utf-8';
        $c->response->content_type("$ct; charset=$charset");
    }
    $c->res;
}

sub _template {
    my ( $self, $c ) = @_;
    my $template = $c->stash->{template}
        || $c->action . $self->config->{TEMPLATE_EXTENSION};
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
    $self->types->mime_type_of($format) || 'text/plain';
}

__PACKAGE__->meta->make_immutable;

1;

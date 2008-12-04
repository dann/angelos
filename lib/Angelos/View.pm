package Angelos::View;
use Moose;
use Angelos::Home;

with 'Angelos::Component';

has 'engine' => (
    is  => 'rw',
    isa => 'Angelos::View::Engine',
);

has 'types' => ( is => 'rw', );

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

no Moose;

sub render {
    my ( $self, $c, $args ) = @_;
    my $format   = $c->stash->{format};
    my $template = $c->stash->{template};

    #FIXME
    my $template_path = $c->stash->{template_path};
    return undef unless $format || $template || $template_path;

    my $stash = { %{ $c->stash } };
    $c->stash->{C} = $self->context;
    $c->stash->{base} ||= $c->req->base;

    my $output = $self->do_render( $c, $template, $stash, $args );
    return undef unless $output;

    $self->_build_response( $c, $output );

    return 1;
}

sub _do_render {
    my ( $self, $c, $template, $stash, $args ) = @_;
    my $output = eval {
        $self->engine->render_template(
            template => $template,
            stash    => $stash,
            args     => $args
        );
    };
    if ($@) {
        my $error = "Couldn't render template '$template': $@";
        $c->log( error => $error );
    }

}

sub _build_response {
    my ( $self, $c, $output ) = @_;

    $c->res->code(200) unless $c->res->code;
    $c->res->body($output);
    my $type = $self->types->type( $c->stash->{format} ) || 'text/plain';

    unless ( $c->res->content_type ) {
        my $ct      = $self->type;
        my $charset = 'utf-8';
        $c->response->content_type("$ct; charset=$charset");
    }
    $c->res;
}

__PACKAGE__->meta->make_immutable;

1;

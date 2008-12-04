package Angelos::View;
use Moose;
use Angelos::View::Engine::TT;
use Angelos::Home;

with 'Angelos::Component';

has 'engine' => (
    isa     => 'Angelos::View::Engine',
    default => sub {
        Angelos::View::Engine::TT->new;
    }
);

has 'types' => (
    is      => 'rw',
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

no Moose;

sub render {
    my ( $self, $c, $args ) = @_;
    my $format        = $c->stash->{format};
    my $template      = $c->stash->{template};
    my $template_path = $c->stash->{template_path};
    return undef unless $format || $template || $template_path;

    my $stash = { %{ $c->stash } };
    $c->stash->{C} = $self->context;
    $c->stash->{base} ||= $c->req->base;
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
    return undef unless $output;

    $self->_build_response( $c, $output );

    # Success!
    return 1;
}

sub _build_response {
    my ( $self, $c, $output ) = @_;

    # Response
    my $res = $c->res;
    $res->code(200) unless $c->res->code;
    $res->body($output);

    my $type = $self->types->type($c->stash->format) || 'text/plain';
    $res->headers->content_type($type);

}

__PACKAGE__->meta->make_immutable;

1;

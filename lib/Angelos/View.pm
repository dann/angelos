package Angelos::View;
use Moose;
use Angelos::View::Engine::TT;
use Angelos::Home;

with 'Angelos::Component';

has 'engine' => (
    isa     => 'Angelos::View::Engine',
    default => sub {

        # FIXME
        Angelos::View::Engine::TT->new;
    }
);

has 'CONTENT_TYPE' => (
    is      => 'rw',
    default => sub {
        'text/html';
    }
);

has 'INCLUDE_PATH' => (
    is      => 'rw',
    default => sub {
        [ Angelos::Home->path_to('root') ];
    },
);

no Moose;

sub render {
    my ( $self, $c, $template, $args ) = @_;
    $self->_build_args($args);
    my $stash = { %{ $c->stash } };
    $stash->{C} = $self->context;
    $stash->{base} ||= $c->req->base;
    my $output
        = eval { $self->engine->render_template( $template, $stash, $args ); };
    if ($@) {
        my $error = "Couldn't render template '$template': $@";
        $c->log( error => $error );
    }
    return $output;
}

sub _build_args {
    my ( $self, $args ) = @_;
    $args->{INCLUDE_PATH} = $self->INCLUDE_PATH;
    $args->{CONTENT_TYPE} = $self->CONTENT_TYPE;
    $args;
}

__PACKAGE__->meta->make_immutable;

1;

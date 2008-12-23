package Angelos::Context;
use Mouse;
use Carp ();
use Angelos::Logger;

has 'app' => (
    is       => 'rw',
    required => 1,
    handles  => [qw(controller log)],
);

has 'request' => (
    is       => 'rw',
    required => 1
);

has 'response' => (
    is       => 'rw',
    required => 1
);

has 'stash' => (
    is      => 'rw',
    default => sub {
        +{};
    }
);

no Mouse;

sub req {
    my $self = shift;
    $self->request;
}

sub res {
    my $self = shift;
    $self->response;
}

sub view {
    my ( $self, $view ) = @_;
    $view ||= 'TT';
    my $v = $self->app->view($view);
    Carp::croak "view $view doesn't exist" unless $v;
    $v->context($self);
    $v;
}

sub error {
}

__PACKAGE__->meta->make_immutable;

1;


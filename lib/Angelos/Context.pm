package Angelos::Context;
use Mouse;

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

no Mouse;

sub req {
    my $self = shift;
    $self->request;
}

sub res {
    my $self = shift;
    $self->response;
}

sub render {
    my ( $self, $template, $params ) = @_;
    my $view = $params->{view} || 'TT';
    return $self->app->view($view)->render( $self->app, $template, $params );
}

sub error {
}

__PACKAGE__->meta->make_immutable;

1;

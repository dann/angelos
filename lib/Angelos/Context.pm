package Angelos::Context;
use Moose;
with 'MooseX::Object::Pluggable';

has 'app' => (
    is       => 'rw',
    required => 1
);

has 'request' => (
    is       => 'rw',
    required => 1
);

has 'response' => (
    is       => 'rw',
    required => 1
);

no Moose;

sub req {
    my $self = shift;
    $self->request;
}

sub res {
    my $self = shift;
    $self->response;
}

# need to consider this method should alive in context class
sub log {
}

# hmm. which class should this method have?
sub session {
}

sub render {
    my ( $self, $template, $params) = @_;
    my $view = $params->{view} || 'TT';
    return $self->app->view($view)->render($self->app, $template, $params);
}

sub controller {
    my ($self, $controller) = @_;
    $self->app->controller($controller);
}

__PACKAGE__->meta->make_immutable;

1;

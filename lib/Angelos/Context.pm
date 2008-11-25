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

sub response {
    my $self = shift;
    $self->response;
}

sub log {

}

# hmm. which class should this method have?
sub session {
}

sub render {
    my ( $self, $options ) = @_;
    my $view = $options->{view} || 'TT';
    return $self->app->view($view)->render($options);
}

__PACKAGE__->meta->make_immutable;

1;

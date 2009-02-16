package TestApp::Web::Controller::Root;
use Angelos::Class;
extends 'Angelos::Controller';

sub index {
    my ( $self, $params ) = @_;
    $self->res->body('HelloWorld');
}

sub japanese {
    my ($self, $params) = @_;
    warn $self->loc('Hello') . "\n";
}

sub error {
    my ($self, $params) = @_;
    die 'ERROR';
}

__END_OF_CLASS__

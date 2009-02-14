package TestApp::Web::Controller::Books;
use Angelos::Class;
extends 'Angelos::Controller';

sub index {
    my ($self, $params) = @_;
    $self->res->body('Hello world in Book controller');
    $self->res->code(200);
}

__END_OF_CLASS__

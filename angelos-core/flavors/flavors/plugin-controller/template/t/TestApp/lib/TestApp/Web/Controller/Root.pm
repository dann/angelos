package TestApp::Web::Controller::Root;
use Angelos::Class;
extends 'Angelos::Controller';

sub index {
    my ($self, $params) = @_;
    $self->res->code(200);
    $self->res->body('ok');
}

__END_OF_CLASS__

__END__


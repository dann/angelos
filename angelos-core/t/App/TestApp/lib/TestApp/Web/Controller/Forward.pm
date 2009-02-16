package TestApp::Web::Controller::Forward;
use Angelos::Class;
use Data::Dumper;
extends 'Angelos::Controller';

sub forward_test {
    my ($self, $params) = @_;
    $self->forward(controller => 'Books', action => 'index');
}

sub detach_test {
    my ($self, $params) = @_;
    $self->detach(controller => 'Books', action => 'index');
}

__END_OF_CLASS__

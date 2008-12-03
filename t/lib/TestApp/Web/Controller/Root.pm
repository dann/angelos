package TestApp::Web::Controller::Root;
use Moose;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    $c->render('index.tt', +{});
}

sub hello_world {
    return 'hello world';
}

1;

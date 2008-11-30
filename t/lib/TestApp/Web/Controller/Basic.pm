package TestApp::Web::Controller::Basic;
use Moose;
extends 'Angelos::Controller';

sub say_hello_world {
    return 'hello world';
}

1;

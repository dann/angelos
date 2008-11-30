package TestApp::Web::Controller::Basic;
use Moose;
extends 'Angelos::Controller';

sub hello_world {
    return 'hello world';
}

1;

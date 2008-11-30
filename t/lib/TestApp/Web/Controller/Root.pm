package TestApp::Web::Controller::Root;
use Moose;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    log('index');
}

sub hello_world {
    return 'hello world';
}

1;

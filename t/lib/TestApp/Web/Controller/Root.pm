package TestApp::Web::Controller::Root;
use Moose;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    print "index\n";
}

sub hello_world {
    return 'hello world';
}

1;

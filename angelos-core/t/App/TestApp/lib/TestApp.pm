package TestApp;
use Angelos::Class;
use TestApp::Logger;
use TestApp::Home;
use TestApp::Config;
extends 'Angelos';

sub create_config {
    TestApp::Config->instance;
}

sub create_logger {
    TestApp::Logger->instance;
}

sub create_home {
    TestApp::Home->instance;
}

__END_OF_CLASS__

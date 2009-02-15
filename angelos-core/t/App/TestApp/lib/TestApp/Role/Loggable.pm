package TestApp::Role::Loggable;
use Mouse::Role;
use TestApp::Logger;

sub log {
    TestApp::Logger->instance;
}

1;

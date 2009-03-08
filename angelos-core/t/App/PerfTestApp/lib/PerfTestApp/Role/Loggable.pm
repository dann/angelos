package TestApp::Role::Loggable;
use Mouse::Role;
use PerfTestApp::Logger;

sub log {
    PerfTestApp::Logger->instance;
}

1;

package PerfTestApp::Role::Configurable;
use Mouse::Role;
use PerfTestApp::Config;

sub config {
    PerfTestApp::Config->instance;
}

1;

package PerfTestApp::Role::HomeAware;
use Mouse::Role;
use PerfTestApp::Home;

sub home {
    PerfTestApp::Home->instance;
}

1;

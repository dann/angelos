package TestApp::Role::HomeAware;
use Mouse::Role;
use TestApp::Home;

sub home {
    TestApp::Home->instance;
}

1;

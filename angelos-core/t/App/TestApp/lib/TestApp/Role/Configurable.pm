package TestApp::Role::Configurable;
use Mouse::Role;
use TestApp::Config;

sub config {
    TestApp::Config->instance;
}

1;

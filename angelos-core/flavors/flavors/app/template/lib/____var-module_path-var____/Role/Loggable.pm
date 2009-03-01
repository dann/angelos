package TestApp::Role::Loggable;
use Mouse::Role;
use [% module %]::Logger;

sub log {
    [% module %]::Logger->instance;
}

1;

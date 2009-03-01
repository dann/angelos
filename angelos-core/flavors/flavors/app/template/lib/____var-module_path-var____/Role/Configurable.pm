package [% module %]::Role::Configurable;
use Mouse::Role;
use [% module %]::Config;

sub config {
    [% module %]::Config->instance;
}

1;

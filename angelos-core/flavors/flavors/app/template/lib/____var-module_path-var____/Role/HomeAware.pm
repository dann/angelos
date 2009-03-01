package [% module %]::Role::HomeAware;
use Mouse::Role;
use [% module %]::Home;

sub home {
    [% module %]::Home->instance;
}

1;

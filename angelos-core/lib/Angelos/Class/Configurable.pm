package Angelos::Class::Configurable;
use Mouse::Role;
use Angelos::Config;

sub config {
    Angelos::Config->instance;
}

1;

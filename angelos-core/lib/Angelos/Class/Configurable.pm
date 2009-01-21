package Angelos::Class::Configurable;
use Angelos::Role;
use Angelos::Config;

sub config {
    Angelos::Config->instance;
}

1;

package Angelos::Class::Loggable;
use Mouse::Role;
use Angelos::Logger;

sub log {
    Angelos::Logger->instance;
}

1;

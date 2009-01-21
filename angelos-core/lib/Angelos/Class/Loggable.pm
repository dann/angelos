package Angelos::Class::Loggable;
use Angelos::Role;
use Angelos::Logger;

sub log {
    Angelos::Logger->instance;
}

1;

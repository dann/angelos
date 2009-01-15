package Angelos::Class::Loggable;
use Mouse::Role;
use Angelos::Logger;

sub log {
    my ($self, %log) = @_;
    Angelos::Logger->instance->log(%log);
}

1;

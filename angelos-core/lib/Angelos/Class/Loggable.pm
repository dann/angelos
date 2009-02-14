package Angelos::Class::Loggable;
use Angelos::Role;
use Angelos::Utils;

sub log {
    my $self = shift;
    Angelos::Utils::context()->logger;
}

1;

package Angelos::Class::Loggable;
use Angelos::Role;
use Angelos::Logger;
use Angelos::Utils;

sub log {
    my $self = shift;
    # TODO Angelos or Angelos::Engine ?
    Angelos::Utils::context()->logger;
}

1;

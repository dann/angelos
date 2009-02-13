package Angelos::Class::Loggable;
use Angelos::Role;
use Angelos::Logger;
use Angelos::Registrar;

sub log {
    my $self = shift;
    # TODO Angelos or Angelos::Engine ?
    Angelos::Registrar::context()->engine->logger;
}

1;

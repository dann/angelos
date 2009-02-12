package Angelos::Class::Configurable;
use Angelos::Role;
use Angelos::Config;
# use Angelos::Config;
use Angelos::Registrar;

sub config {
    my $config = Angelos::Config->new unless Angelos::Registrar::context()->engine;
    $config ||= Angelos::Registrar::context()->engine->config;
    $config;
}

1;

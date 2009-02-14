package Angelos::Class::Configurable;
use Angelos::Role;
use Angelos::Config;
use Angelos::Utils;

sub config {
    my $config = Angelos::Utils::context()->config;
    $config;
}

1;

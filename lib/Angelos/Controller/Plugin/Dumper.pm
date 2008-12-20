package Angelos::Controller::Plugin::Dumper;
use Mouse::Role;
use Data::Dumper;

sub dump {
    warn Dumper @_;
}

1;

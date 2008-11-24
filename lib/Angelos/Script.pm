package Angelos::Script;
use Moose;
with 'MooseX::Getopt', 'Angelos::Config';
no Moose;

sub run {
}

__PACKAGE__->meta->make_immutable;

1;

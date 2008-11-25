package Angelos::Script;
use Moose;
with 'MooseX::Getopt', 'Angelos::Config';
no Moose;

sub run {
    Carp::croak('Method "run" not implemented by subclass')
}

__PACKAGE__->meta->make_immutable;

1;

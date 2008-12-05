package Angelos::Script;
use Mouse;
use Carp;
#with 'MooseX::Getopt', 'Angelos::Config';
no Mouse;

sub run {
    Carp::croak('Method "run" not implemented by subclass')
}

__PACKAGE__->meta->make_immutable;

1;

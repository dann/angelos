package Angelos::View::Engine::TT;
use Moose;
extends 'Angelos::View::Engine';

no Moose;

sub render {
    my ($self, $option) = @_;
    warn 'TT';
}

__PACKAGE__->meta->make_immutable;

1;

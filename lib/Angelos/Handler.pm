package Angelos::Handler;
use Mouse;
use Carp ();
extends 'Angelos::Engine::Base';

no Mouse;

__PACKAGE__->meta->make_immutable;

1;

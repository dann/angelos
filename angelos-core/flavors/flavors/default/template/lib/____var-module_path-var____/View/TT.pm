package [% module %]::View::TT;
use Mouse;
extends 'Angelos::View::TT';

no Mouse;

__PACKAGE__->meta->make_immutable;

1;

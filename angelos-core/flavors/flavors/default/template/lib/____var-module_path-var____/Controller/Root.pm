package [% module %]::Controller::Root;
use Mouse;
extends 'Angelos::Controller';

no Mouse;

sub index {
    my ($self, $c, $params) = @_;
    $c->view("TT")->render;
}

__PACKAGE__->meta->make_immutable;

1;

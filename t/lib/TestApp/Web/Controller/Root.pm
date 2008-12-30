package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
use Carp ();
use Angelos::Utils;
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    $c->view('TT')->render;
}

sub view {
    my ($self, $c, $params) = @_;
    $c->stash->{template} = 'index';

}

1;

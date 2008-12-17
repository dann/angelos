package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
use Carp ();
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    Carp::confess 'ooooooooooooops';
    $c->stash->{template} = 'index';
    $c->res->body('こんにちは');
}

sub view {
    my ($self, $c, $params) = @_;
    $c->stash->{template} = 'index';
    $c->view('TT')->render(+{});
}

1;

package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    $c->stash->{template} = 'index';
    $c->res->body('hello world');
}

sub view {
    my ($self, $c, $params) = @_;
    $c->stash->{template} = 'index';
    $c->view('TT')->render(+{});
}

1;

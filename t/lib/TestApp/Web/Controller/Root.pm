package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    $c->stash->{template} = 'index';
    warn $c->view('TT')->render(+{});
}

1;

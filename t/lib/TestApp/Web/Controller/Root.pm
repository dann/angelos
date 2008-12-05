package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
extends 'Angelos::Controller';

sub index {
    my ($self, $c, $params) = @_;
    $c->view('TT')->render('index', +{});
}


1;

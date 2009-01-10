package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Logger;
use Carp ();
use Angelos::Utils;
extends 'Angelos::Controller';

sub index {
    my ( $self, $c, $params ) = @_;
    $c->res->body('HelloWorld');
}

sub tt {
    my ( $self, $c, $params ) = @_;
    $c->view('TT')->render( { name => 'Yamada Taro' } );
}

1;

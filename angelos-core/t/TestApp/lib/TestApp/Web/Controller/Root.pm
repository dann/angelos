package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Utils;
extends 'Angelos::Controller';

sub index {
    my ( $self, $c, $params ) = @_;
    $self->log(
        level => 'debug',
        message => 'index method in Root controller',
    );
    $c->res->body('HelloWorld');
}

sub tt {
    my ( $self, $c, $params ) = @_;
    $c->view('TT')->render( { name => 'Yamada Taro' } );
}

__PACKAGE__->meta->make_immutable;

1;

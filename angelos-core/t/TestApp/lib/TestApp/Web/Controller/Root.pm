package TestApp::Web::Controller::Root;
use Mouse;
use Angelos::Utils;
extends 'Angelos::Controller';

with 'Angelos::Class::Localizable';

sub index {
    my ( $self, $c, $params ) = @_;
    $self->log(
        level => 'debug',
        message => 'index method in Root controller',
    );
    #$c->redirect('http://www.google.co.jp');
    #$c->res->body('HelloWorld');
}

sub tt {
    my ( $self, $c, $params ) = @_;
    $c->view('TT')->render( { name => 'Yamada Taro' } );
}

sub japanese {
    my ($self, $c, $params) = @_;
    warn $self->loc('Hello') . "\n";
}

__PACKAGE__->meta->make_immutable;

1;

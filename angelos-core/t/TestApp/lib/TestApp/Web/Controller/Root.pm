package TestApp::Web::Controller::Root;
use Angelos::Class;
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

sub forward {
    my ($self, $c, $params) = @_;
    $c->forward(controller => 'Books', action => 'index');
}

sub detach {
    my ($self, $c, $params) = @_;
    $c->detach(controller => 'Books', action => 'index');
}

__END_OF_CLASS__

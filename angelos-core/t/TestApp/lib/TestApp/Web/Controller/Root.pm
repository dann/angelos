package TestApp::Web::Controller::Root;
use Angelos::Class;
use Angelos::Utils;
extends 'Angelos::Controller';

with 'Angelos::Class::Localizable';

sub index {
    my ( $self, $params ) = @_;
    $self->log->debug('index method in Root controller');
    #$c->redirect('http://www.google.co.jp');
    $self->res->body('HelloWorld');
}

sub tt {
    my ( $self, $c, $params ) = @_;
    $self->render( params => { name => 'Yamada Taro' } );
    #$self->view('TT')->render( { name => 'Yamada Taro' } );
}

sub japanese {
    my ($self, $c, $params) = @_;
    warn $self->loc('Hello') . "\n";
}

sub forward_test {
    my ($self, $c, $params) = @_;
    $self->forward(controller => 'Books', action => 'index');
}

sub detach_test {
    my ($self, $c, $params) = @_;
    $self->detach(controller => 'Books', action => 'index');
}

__END_OF_CLASS__

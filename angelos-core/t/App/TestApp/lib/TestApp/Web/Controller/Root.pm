package TestApp::Web::Controller::Root;
use Angelos::Class;
use Angelos::Utils;
extends 'Angelos::Controller';

with 'Angelos::Class::Localizable';

sub index {
    my ( $self, $params ) = @_;
    $self->res->body('HelloWorld');
}

sub tt {
    my ( $self, $params ) = @_;
    $self->render( params => { name => 'Yamada Taro' } );
    #$self->view('TT')->render( { name => 'Yamada Taro' } );
}

sub japanese {
    my ($self, $params) = @_;
    warn $self->loc('Hello') . "\n";
}

sub forward_test {
    my ($self, $params) = @_;
    $self->forward(controller => 'Books', action => 'index');
}

sub detach_test {
    my ($self, $params) = @_;
    $self->detach(controller => 'Books', action => 'index');
}

sub error {
    my ($self, $params) = @_;
    die 'ERROR';
}

__END_OF_CLASS__

package TestApp::Web::Controller::View;
use Angelos::Class;
extends 'Angelos::Controller';

sub tt {
    my ( $self, $params ) = @_;
    $self->render( params => { name => 'Yamada Taro' } );
}

__END_OF_CLASS__

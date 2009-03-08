package PerfTestApp::Web::Controller::Root;
use Angelos::Class;
use HTTP::Engine::Response;
extends 'Angelos::Controller';

sub index {
    my ( $self, $params ) = @_;
    $self->response(
        HTTP::Engine::Response->new( code => 200, body => 'hello' ) );

    #$self->render(params => {name => 'Yamada Taro'});
}

__END_OF_CLASS__

__END__


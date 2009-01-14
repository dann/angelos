package TestApp::Web::Controller::PluginDumper;
use Mouse;
use Carp ();
use Angelos::Utils;
extends 'Angelos::Controller';

sub dumper {
    my ( $self, $c, $params ) = @_;
    $self->dump($c->req);
    $c->res->body('HelloWorld');
}

1;

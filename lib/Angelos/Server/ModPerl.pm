package Angelos::Server::ModPerl;
use Mouse;
use Angelos;
extends 'HTTP::Engine::Interface::ModPerl';

no Mouse;

sub create_engine {
    my ( $class, $r, $context_key ) = @_;
    my $app_class = $class->_load_app_class;
    $class->_setup_home;

    my $app = $app_class->new;
    $app->setup;
    return $app->engine;
}

sub _load_app_class {
    my $app_class = $ENV{ANGELOS_BASECLASS};
    Mouse::load_class($app_class);
}

sub _setup_home {
    $ENV{ANGELOS_HOME} = $ENV{DOCUMENT_ROOT};
}

__PACKAGE__->meta->make_immutable;

1;

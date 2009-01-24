package Angelos::BootLoader;
use Angelos::Class;
use Angelos::Engine;
use Angelos::Utils;
use Angelos::Home;
use Angelos::Request;
use Angelos::Dispatcher::Routes::Builder;
use Angelos::Exceptions qw(rethrow_exception);

with 'Angelos::Class::Loggable';
with 'Angelos::Class::Pluggable';
with 'Angelos::Class::Configurable';

has _plugin_app_ns => (
    +default => sub {
        ['Angelos::BootLoader'];
    }
);

has 'conf' => ( is => 'rw', );

has 'appclass' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    required => 1,
    lazy     => 1,
    builder  => 'build_root',
);

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'port' => (
    is      => 'rw',
    isa     => 'Int',
    default => 3000,
);

has 'server' => ( is => 'rw', );

has 'engine' => (
    is      => 'rw',
    handles => ['controller'],
);

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

sub run {
    shift->SETUP;
}

sub SETUP {
    my $self = shift;
    eval {
        $self->setup_home;
        $self->setup_application_class;
        $self->setup_bootloader_plugins;
        $self->setup_request;
        $self->setup_response;
        $self->setup_engine;
        $self->setup_logger;
        $self->setup_components;
        $self->setup_dispatcher;
    };
    if ( my $e = $@ ) {
        rethrow_exception($e);
    }
    return $self->engine;
}

sub setup_mixins {
    Angelos::Mixin::Loader->load;
}

sub setup_application_class {
    my $self = shift;
    Angelos::Config->application_class( $self->appclass );
}

sub setup_bootloader_plugins {
    my $self = shift;
    if ( $self->is_debug ) {
        my @plugins
            = ( { module => 'ShowComponents' }, { module => 'ShowRoutes' } );
        $self->load_plugin( $_->{module} ) for @plugins;
    }
}

sub setup_home {
    my $self = shift;
    my $home = Angelos::Home->home( $self->appclass );
    return $home;
}

sub setup_request {
    my $self = shift;
    Angelos::Request->setup;
}

sub setup_response {
}

sub setup_engine {
    my $self   = shift;
    my $engine = Angelos::Engine->new(
        root   => $self->root,
        host   => $self->host,
        port   => $self->port,
        server => $self->server,
        conf   => $self->conf,
    );
    $engine->load_plugin( $_->{module} ) for $self->config->plugins('engine');
    $self->engine($engine);
    $engine;
}

sub setup_logger {
    Angelos::Logger->instance;
}

sub setup_components {
    my $self       = shift;
    my $components = $self->engine->component_manager->setup( $self->appclass );
    $components;
}

sub setup_dispatcher {
    my $self = shift;
    $self->_setup_dispatch_rules;
}

sub _setup_dispatch_rules {
    my $self     = shift;
    my $routeset = $self->build_routeset;
    $self->engine->set_routeset($routeset);
}

sub build_routeset {
    my $self = shift;
    my $routeset
        = Angelos::Dispatcher::Routes::Builder->new->build_from_config;
    $routeset->[0];
}

sub build_root {
    Angelos::Home->path_to( 'share', 'root' );
}

sub is_debug {
    my $self = shift;
    my $is_debug;
    $is_debug ||= $ENV{ANGELOS_DEBUG};
    $is_debug ||= Angelos::Utils::env_value( ref $self, 'DEBUG' );
    $is_debug ||= $self->debug;
    return $is_debug;
}

__END_OF_CLASS__

__END__

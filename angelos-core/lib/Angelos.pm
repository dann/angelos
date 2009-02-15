package Angelos;
use 5.00800;
our $VERSION = '0.01';
use Angelos::Class;
use Angelos::MIMETypes;
use Angelos::Registrar;
use Angelos::Home;
use Angelos::ProjectStructure;
use Angelos::Engine;
use Angelos::Config;
use Angelos::Logger;
use Angelos::Utils;
use Angelos::Dispatcher::Routes::Builder;
use Angelos::Registrar;
use Angelos::Exceptions qw(rethrow_exception);
use Exception::Class;

with 'Angelos::Class::Pluggable';

has _plugin_app_ns => (
    +default => sub {
        ['Angelos'];
    }
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

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

has 'home' => (
    is      => 'rw',
    isa     => 'Angelos::Home',
    handles => [qw(path_to)],
);

has 'engine' => (
    is => 'rw',
    handles =>
        [qw(controller model view forward detach full_forward full_detach)],
);

has 'config' => ( is => 'rw', );

has 'logger' => ( is => 'rw', );

has 'project_structure' => ( is => 'rw', );

has 'available_mimetypes' => (
    is      => 'rw',
    default => sub {
        Angelos::MIMETypes->new;
    }
);

has 'request' => (
    is      => 'rw',
    handles => [qw(params)],
);

has 'response' => ( is => 'rw', );

has 'stash' => (
    is      => 'rw',
    default => sub {
        +{};
    }
);

has 'finished' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has '_match' => ( is => 'rw', );

# This attribute is used for test only
has 'request_handler' => ( is => 'rw', );

sub BUILD {
    my $self = shift;
    $self->setup;
}

sub setup {
    my $self = shift;

    no warnings 'redefine';
    local *Angelos::Registrar::context = sub {$self};
    eval {
        $self->setup_home;
        $self->setup_config;
        $self->setup_project_structure;
        $self->setup_logger;
        $self->setup_bootloader_plugins;
        $self->setup_engine;
        $self->setup_components;
        $self->setup_dispatcher;
    };
    if ( my $e = Exception::Class->caught() ) {
        rethrow_exception($e);
    }
}

sub run {
    my $self = shift;
    $self->engine->run(@_);
}

sub setup_home {
    my $self = shift;
    my $home = $self->create_home;
    $self->home($home);
    $home;
}

sub create_home {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement create_home method' 
    );
}

sub setup_config {
    my $self   = shift;
    my $config = $self->create_config;
    $self->config($config);
    $config;
}

sub create_config {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement create_config method' 
    );
}

sub setup_logger {
    my $self   = shift;
    my $logger = $self->create_logger;
    $self->logger($logger);
    $logger;
}

sub create_logger {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement create_logger method' 
    );
}

sub setup_project_structure {
    my $self = shift;
    $self->project_structure(
        Angelos::ProjectStructure->new( home => $self->home ) );
}

sub setup_bootloader_plugins {
    my $self = shift;
    if ( $self->is_debug ) {
        my @plugins
            = ( { module => 'ShowComponents' }, { module => 'ShowRoutes' } );
        $self->load_plugin( $_->{module} ) for @plugins;
    }
}

sub setup_engine {
    my $self   = shift;
    my $engine = Angelos::Engine->new(
        host   => $self->host,
        port   => $self->port,
        server => $self->server,
        config => $self->config,
        logger => $self->logger,
        root   => $self->project_structure->root_dir,
    );
    $engine->app($self);
    $engine->request_handler( $self->request_handler )
        if $self->request_handler;
    $self->engine($engine);
    $engine;
}

sub setup_components {
    my $self       = shift;
    my $components = $self->engine->component_manager->setup;
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
    $routeset;
}

sub build_routeset {
    my $self = shift;
    my $routeset
        = Angelos::Dispatcher::Routes::Builder->new->build_from_config;
    $routeset->[0];
}

sub is_debug {
    my $self = shift;
    my $is_debug;
    $is_debug ||= $ENV{ANGELOS_DEBUG};
    $is_debug ||= Angelos::Utils::env_value( ref $self, 'DEBUG' );
    $is_debug ||= $self->debug;
    return $is_debug;
}

sub app_class {
    my $self = shift;
    ref $self;
}

sub req {
    shift->request;
}

sub res {
    shift->response;
}

__END_OF_CLASS__

__END__

=head1 NAME

Angelos -

=head1 SYNOPSIS

  package MyApp;
  use Angelos::Class;
  extends 'Angelos';

  __END_OF_CLASS__

  use MyApp;
  my $app = MyApp->new;
  $app->run;
  1;

Edit conf/routes.yaml to make dispatch rules and create an application class like below.

=head1 DESCRIPTION

Angelos is yet another web application framework

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 CONTRIBUTORS

Many people have contributed ideas, inspiration, fixes and features to
the Angelos.  Their efforts continue to be very much appreciated.
Please let me know if you think anyone is missing from this list.

Lyo Kato, Tomyhero Teranishi, vkgtaro, hideden, bonnu

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

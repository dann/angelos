package Angelos;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp ();
use Mouse;
use Angelos::Server;
use Angelos::Utils;
use Angelos::Home;
use Angelos::Component::Loader;
use YAML;
use Angelos::Dispatcher::Routes::Builder;
use Angelos::Debug;

has 'conf' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    required => 1,
    default  => sub { Angelos::Home->path_to('root')->absolute },
);

has 'host' => (
    is      => 'rw',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    default  => 10070,
    required => 1,
);

has 'server' => (
    is      => 'rw',
    default => 'ServerSimple',
);

has 'server_instance' => (
    is      => 'rw',
    handles => ['controller'],
);

sub BUILD {
    my $self = shift;

    my $server = $self->setup;
}

sub run {
    my $self = shift;
    my $exit = sub { CORE::die('caught signal') };
    eval {
        local $SIG{INT}  = $exit;
        local $SIG{QUIT} = $exit;
        local $SIG{TERM} = $exit;
        $self->server_instance->run;
    };
}

sub setup {
    my $self   = shift;
    my $server = Angelos::Server->new(
        root   => $self->root,
        host   => $self->host,
        port   => $self->port,
        server => $self->server,
        conf   => $self->conf,
    );

    # FIXME move to default
    $self->server_instance($server);

    $self->setup_logger;
    $self->setup_home;
    $self->setup_components;
    $self->setup_dispatcher;
    $server;
}

sub setup_home {
    my $self = shift;
}

sub setup_logger {
    my $self = shift;

    # $self->server_instance->logger->path();
}

sub setup_components {
    my $self = shift;
    my $components
        = $self->server_instance->component_loader->load_components(
        ref $self );
    Angelos::Debug->show_components($components)
        if Angelos::Debug->is_debug_mode;
    $components;
}

sub setup_dispatcher {
    my $self = shift;
    $self->_setup_dispatch_rules;
}

sub _setup_dispatch_rules {
    my $self   = shift;
    my $routes = $self->build_routes;
    $self->server_instance->add_route($_) for @{$routes};
}

sub build_routes {
    my $self = shift;
    my $routes_conf
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    my $routes = Angelos::Dispatcher::Routes::Builder->new->build( ref $self,
        $routes_conf );
    Angelos::Debug->show_dispatch_table($routes)
        if Angelos::Debug->is_debug_mode;
    $routes;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Angelos -

=head1 SYNOPSIS
Edit conf/routes.yaml to make dispatch rules and create an application class like below.

  package MyApp;
  use Mouse;
  extends 'Angelos';

  use MyApp;
  MyApp->new->run;

=head1 DESCRIPTION

Angelos is

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

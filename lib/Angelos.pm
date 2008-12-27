package Angelos;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp ();
use Mouse;
use Angelos::Engine;
use Angelos::Utils;
use Angelos::Home;
use Angelos::Dispatcher::Routes::Builder;
use Angelos::Config;
use Angelos::Logger;
use Angelos::Exceptions;
use Angelos::I18N;

with 'Angelos::Class::Mixinable';

has '_mixin_ns' => (
    +default => sub {
        'Debug';
    }
);

has 'conf' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    required => 1,
    lazy     => 1,
    builder  => 'build_root',
);

has 'host' => (
    is      => 'rw',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    default  => 3000,
    required => 1,
);

has 'server' => (
    is      => 'rw',
);

has 'engine' => (
    is      => 'rw',
    handles => ['controller'],
);

no Mouse;

sub run {
    my $self = shift;
    $self->engine->run;
}

sub setup {
    my $self = shift;
    $self->setup_home;
    $self->setup_mixins;
    $self->setup_engine;
    $self->setup_logger;
    $self->setup_components;
    $self->setup_dispatcher;
}

sub setup_mixins {
    my $self = shift;
    $self->setup_debug_mixins;
}

sub setup_debug_mixins {
    my $self = shift;
    $self->load_mixin($_->{module}) for Angelos::Config->mixins('debug');
}

sub setup_home {
    my $self = shift;
    my $home;
    if ( my $env = Angelos::Utils::env_value( ref $self, 'HOME' ) ) {
        $home ||= Angelos::Home->home($env);
    }
    my $appclass = ref $self;
    $home = Angelos::Home->home($appclass);
    $home;
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
    $engine->load_plugin($_->{module}) for Angelos::Config->plugins('engine');
    $self->engine($engine);
    $engine;
}

sub setup_logger {
    my $self = shift;
    $self->engine->logger( Angelos::Logger->new );
}

sub setup_components {
    my $self = shift;
    my $components
        = $self->engine->component_loader->load_components(
        ref $self );
    $components;
}

sub setup_dispatcher {
    my $self = shift;
    $self->_setup_dispatch_rules;
}

sub _setup_dispatch_rules {
    my $self   = shift;
    my $routes = $self->build_routes;
    $self->engine->add_route($_) for @{$routes};
}

sub build_routes {
    my $self   = shift;
    my $routes = Angelos::Dispatcher::Routes::Builder->new->build_from_config;
    $routes;
}

sub build_root {
    Angelos::Home->path_to('root')->absolute;
}

sub is_debug {
    $ENV{ANGELOS_DEBUG} ? 1 : 0;
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Angelos -

=head1 SYNOPSIS


  package MyApp;
  use Mouse;
  extends 'Angelos';
  1;

  use MyApp;
  my $app = MyApp->new;
  $app->setup;
  $app->run;
  1;

Edit conf/routes.yaml to make dispatch rules and create an application class like below.

=head1 DESCRIPTION

Angelos is yet another web application framework

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

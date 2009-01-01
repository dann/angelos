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
use Angelos::Debug::Routes;

with 'Angelos::Class::Mixinable';

our $LOGGER;

has _mixin_app_ns => (
    +default => sub {
        ['Angelos'];
    }
);

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
    isa        => 'Str',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    isa        => 'Int',
);

has 'server' => ( is => 'rw', );

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
    $self->setup_application_class;
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

sub setup_application_class {
    my $self = shift;
    Angelos::Config->application_class(ref $self);
}

sub setup_debug_mixins {
    my $self = shift;
    if($self->is_debug) { 
        my @mixins = ({module => 'Components'}, {module => 'Routes'});
        $self->load_mixin( $_->{module} ) for @mixins;
    }
}

sub setup_home {
    my $self = shift;
    my $home = Angelos::Home->guess_home( ref $self );
    Angelos::Home->set_home($home) if -d $home;
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
    $engine->load_plugin( $_->{module} )
        for Angelos::Config->plugins('engine');
    $self->engine($engine);
    $engine;
}

sub setup_logger {
    my $self = shift;
    $LOGGER = Angelos::Logger->instance;
    $self->engine->logger($LOGGER);
}

sub setup_components {
    my $self = shift;
    my $components
        = $self->engine->component_loader->load_components( ref $self );
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
    Angelos::Home->path_to('root')->absolute;
}

sub is_debug {
    my $self = shift;
    my $is_debug = 0; 
    $is_debug ||= $ENV{ANGELOS_DEBUG};
    $is_debug ||=  Angelos::Utils::env_value( ref $self, 'HOME' );
    return $is_debug;
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

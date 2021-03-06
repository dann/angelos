package Angelos::Config;
use strict;
use warnings;
use Angelos::Config::Loader;
use Angelos::Config::Schema;
use Data::Visitor::Callback;
use Angelos::Utils;
use base 'Class::Singleton';

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{config} = Angelos::Config::Loader->load( $self->config_file_path,
        Angelos::Config::Schema->config );
    return $self;
}

sub config_file_path {
    my ( $self, $environment ) = @_;
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement config_file_path method' );
}

sub global {
    my $self = shift;
    my $var  = shift;
    $self->_get( 'global', $var );
}

sub plugins {
    my $self    = shift;
    my $type    = shift;
    my $module  = shift;
    my $plugins = $self->_get( 'plugins', $type );
    unless ($plugins) {
        return wantarray ? () : [];
    }
    if ($module) {
        foreach my $plugin ( @{$plugins} ) {
            if ( $module eq $plugin->{module} ) {
                return $plugin;
            }
        }
        return;
    }
    return wantarray ? @{$plugins} : $plugins;
}

sub mixins {
    my $self   = shift;
    my $type   = shift;
    my $module = shift;
    my $mixins = $self->_get( 'mixins', $type );
    unless ($mixins) {
        return wantarray ? () : [];
    }
    if ($module) {
        foreach my $mixin ( @{$mixins} ) {
            if ( $module eq $mixin->{module} ) {
                return $mixin;
            }
        }
        return;
    }
    return wantarray ? @{$mixins} : $mixins;
}

sub components {
    my $self           = shift;
    my $component_type = shift;
    my $module         = shift;

    my $components = $self->_get( 'components', $component_type );
    unless ($components) {
        if ($module) {
            return +{};
        }
        else {
            return wantarray ? () : [];
        }
    }
    if ($module) {
        foreach my $component ( @{$components} ) {
            if ( $module eq $component->{module} ) {
                return $component;
            }
        }
        return +{};
    }
    return wantarray ? @{$components} : $components;
}

sub middlewares {
    my $self        = shift;
    my $module      = shift;
    my $middlewares = $self->_get('middlewares');
    if ($module) {
        foreach my $middleware ( @{$middlewares} ) {
            if ( $module eq $middleware->{module} ) {
                return $middleware;
            }
        }
        return +{};
    }

    unless ($middlewares) {
        return wantarray ? () : [];
    }
    return wantarray ? @{$middlewares} : $middlewares;
}

sub database {
    my $self   = shift;
    $self->_get('database');
}

sub _get {
    my $self    = shift;
    my $section = shift;
    my $var     = shift;
    unless ( $self->{config}->{$section} ) {
        return;
    }

    unless ($var) {
        return $self->{config}->{$section};
    }
    return $self->{config}->{$section}->{$var};
}

1;

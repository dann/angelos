package Angelos::Config;
use strict;
use warnings;
use base 'Class::Singleton';
use Angelos::Home;
use Angelos::Config::Loader;
use Angelos::Config::Schema;
use Data::Visitor::Callback;

our $APPLICAION_CLASS;

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{config}
        = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'config.yaml' ),
        Angelos::Config::Schema->config );
    return $self;
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
        return undef;
    }
    return wantarray ? @{$plugins} : $plugins;
}

sub mixins {
    my $self    = shift;
    my $type    = shift;
    my $module  = shift;
    my $mixins = $self->_get( 'mixins', $type );
    unless ($mixins) {
        return wantarray ? () : [];
    }
    if ($module) {
        foreach my $mixin( @{$mixins} ) {
            if ( $module eq $mixin->{module} ) {
                return $mixin;
            }
        }
        return undef;
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
    my $module         = shift;
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

sub routes_config_path {
    Angelos::Home->path_to( 'conf', 'routes.pl' );
}

sub _config {
    my $self = shift;
    $self->{config};
}

sub _get {
    my $self    = shift;
    my $section = shift;
    my $var     = shift;
    unless ( $self->_config->{$section} ) {
        return undef;
    }

    unless ($var) {
        return $self->_config->{$section};
    }
    return $self->_config->{$section}->{$var};
}

sub logger_conf_path {
    Angelos::Home->path_to( 'conf', 'log.yaml' );
}

# This is needed to search components fast
sub application_class {
    my ( $class, $application_class ) = @_;
    return $APPLICAION_CLASS if $APPLICAION_CLASS;
    $APPLICAION_CLASS = $application_class if $application_class;
    $APPLICAION_CLASS;
}

1;

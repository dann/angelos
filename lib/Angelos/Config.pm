package Angelos::Config;
use Angelos::Home;
use Angelos::Config::Loader;
use Angelos::Config::Schema;
use Data::Visitor::Callback;

our $CONFIG;
our $APPLICAION_CLASS;

sub global {
    my $class = shift;
    my $var   = shift;
    $class->_get( 'global', $var );
}

sub plugins {
    my $class   = shift;
    my $var     = shift;
    my $module  = shift;
    my $plugins = $class->_get( 'plugins', $var );
    unless ($plugins) {
        return wantarray ? () : [];
    }
    if ($module) {
        foreach my $plugin ( @{$plugins} ) {
            if ( $module eq $plugin->{module} ) {
                return $plugin;
            }
        }
    }
    return wantarray ? @{$plugins} : $plugins;
}

sub components {
    my $class   = shift;
    my $component_type     = shift;
    my $module = shift;

    my $components = $class->_get( 'components', $component_type );
    unless ($components) {
        if($module) {
            return +{};
        } else {
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
    my $class       = shift;
    my $middlewares = $class->_get('middlewares');

    unless ($middlewares) {
        return wantarray ? () : [];
    }
    return wantarray ? @{$middlewares} : $middlewares;
}

sub routes_config_path {
    Angelos::Home->path_to( 'conf', 'routes.pl' );
}

sub _config {
    my $class = shift;
    return $CONFIG if $CONFIG;

    $CONFIG
        = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'config.yaml' ),
        Angelos::Config::Schema->config );
    $CONFIG;
}

sub _get {
    my $class   = shift;
    my $section = shift;
    my $var     = shift;
    unless ( $class->_config->{$section} ) {
        return undef;
    }

    unless ($var) {
        return $class->_config->{$section};
    }
    return $class->_config->{$section}->{$var};
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

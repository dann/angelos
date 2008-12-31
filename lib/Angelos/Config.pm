package Angelos::Config;
use Angelos::Home;
use Angelos::Config::Loader;
use Angelos::Config::Schema;

sub global {
    my $class = shift;
    my $var   = shift;
    $class->_get( 'global', $var );
}

sub plugins {
    my $class   = shift;
    my $var     = shift;
    my $plugins = $class->_get( 'plugins', $var );
    unless ($plugins) {
        return wantarray ? () : [];
    }
    return wantarray ? @{$plugins} : $plugins;
}

sub mixins {
    my $class  = shift;
    my $var    = shift;
    my $mixins = $class->_get( 'mixins', $var );

    unless ($mixins) {
        return wantarray ? () : [];
    }
    return wantarray ? @{$mixins} : $mixins;
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

our $CONFIG;

sub _config {
    my $class = shift;
    return $CONFIG if $CONFIG;

    $CONFIG
        ||= Angelos::Config::Loader->load(
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

1;

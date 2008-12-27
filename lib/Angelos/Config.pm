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
    my $plugins = $class->_config->{plugins};
    unless ($plugins) {
        return wantarray ? () : [];
    }
    $plugins = $plugins->{$var} || [];
    return wantarray ? @{$plugins} : $plugins;
}

sub mixins {
    my $class = shift;
    my $var   = shift;
    $class->_get( 'mixins', $var );
}

sub middlewares {
    my $class = shift;
    $class->_get('middlewares');
}

sub routes {
    my $routes = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    return wantarray ? @{$routes} : $routes;
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
        return +{};
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

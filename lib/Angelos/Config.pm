package Angelos::Config;
use Angelos::Home;
use Angelos::Config::Loader;
use Angelos::Config::Schema;

sub config {
    my $class = shift;
    my $conf
        = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'config.yaml' ),
        Angelos::Config::Schema->config );
    $conf;
}

sub logger_conf_path {
    Angelos::Home->path_to( 'conf', 'log.yaml' );
}

sub controller_plugins {
    my $class   = shift;
    my $plugins = $class->config->{plugins};
    unless ($plugins) {
        return wantarray ? () : [];
    }
    $plugins = $plugins->{controller} || [];
    return wantarray ? @{$plugins} : $plugins;
}

sub view_plugins {
    my $class   = shift;
    my $plugins = $class->config->{plugins};
    unless ($plugins) {
        return wantarray ? () : [];
    }
    $plugins = $plugins->{view} || [];
    return wantarray ? @{$plugins} : $plugins;
}

sub debug_plugins {
    my $class   = shift;
    my $plugins;
    if($ENV{ANGELOS_DEBUG}) {
        $plugins = ['Components', 'Routes'];
        return wantarray ? @{$plugins} : $plugins;
    }

    $plugins = $class->config->{plugins};
    unless ($plugins) {
        return wantarray ? () : [];
    }
    $plugins = $plugins->{debug} || [];
   warn $_ for @{$plugins};
    return wantarray ? @{$plugins} : $plugins;
}

sub routes {
    my $routes = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    return wantarray ? @{$routes} : $routes;
}

sub middlewares {
    my $class = shift;
    return $class->config->{middlewares} || [];
}

1;

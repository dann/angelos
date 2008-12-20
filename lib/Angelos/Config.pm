package Angelos::Config;
use Angelos::Home;
use YAML;

# TODO: cache config?
sub config {
    my $conf
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'config.yaml' ) );
    $conf;
}

sub logger_conf_path {
    Angelos::Home->path_to( 'conf', 'log.yaml' );
}

sub controller_plugins {
    my $class   = shift;
    my $plugins = $class->config->{plugins};
    return [] unless $plugins;
    $plugins = $plugins->{controller} || [];
    return wantarray ? @{$plugins} : $plugins;
}

sub routes {
    my $routes
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    $routes;
}

sub middlewares {
    my $class = shift;
    return $class->config->{middlewares} || [];
}

# TODO: Kwalify
sub validate_logger_config {

}

sub validate_main_config {

}

sub validate_routes_config {

}

1;

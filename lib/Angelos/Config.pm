package Angelos::Config;
use Angelos::Home;
use YAML;

sub logger_conf_path {
    Angelos::Home->path_to( 'conf', 'log.yaml' );
}

sub routes {
    my $routes
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    $routes;
}

1;

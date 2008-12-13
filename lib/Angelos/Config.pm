package Angelos::Config;
use Angelos::Home;
use YAML;

sub load {
    my $conf
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'config.yaml' ) );
    $conf;
}

sub logger_conf_path {
    Angelos::Home->path_to( 'conf', 'log.yaml' );
}

sub routes {
    my $routes
        = YAML::LoadFile( Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    $routes;
}

1;

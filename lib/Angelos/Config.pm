package Angelos::Config;
use Angelos::Home;
use Angelos::Config::Loader;

sub config {
    my $class = shift;
    my $conf
        = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'config.yaml' ),
        $class->config_schema );
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

sub routes {
    my $routes = Angelos::Config::Loader->load(
        Angelos::Home->path_to( 'conf', 'routes.yaml' ) );
    return wantarray ? @{$routes} : $routes;
}

sub middlewares {
    my $class = shift;
    return $class->config->{middlewares} || [];
}

sub config_schema {
    my $schema = {
        type => 'map',

        mapping => {
            components => {
                type    => 'map',
                mapping => {
                    model => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    controller => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    view => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                }
            },
            plugins => {
                type    => 'map',
                mapping => {
                    model => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    controller => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                    view => {
                        type     => 'seq',
                        sequence => [
                            {   type    => 'map',
                                mapping => {
                                    module =>
                                        { type => 'str', required => 1, },
                                    config => { type => 'any', },
                                },
                            },
                        ],
                    },
                }
            },
            middlewares => {
                type     => 'seq',
                sequence => [
                    {   type    => 'map',
                        mapping => {
                            module => { type => 'str', required => 1, },
                            config => { type => 'any', },
                        },
                    },
                ],
            },
        },
    };
    $schema;
}

1;

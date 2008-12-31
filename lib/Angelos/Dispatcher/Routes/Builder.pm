package Angelos::Dispatcher::Routes::Builder;
use Mouse;
use Angelos::Config;
use HTTP::Router;
use Data::Dumper;

sub build_from_config {
    my $self = shift;
    $self->build( Angelos::Config->routes_config_path );
}

sub build {
    my ( $self, $conf ) = @_;
    my $router = eval { require $conf };
    if ($@) {
        die $@;
    }
    my @routeset = $router->routeset;
    \@routeset;
}

1;

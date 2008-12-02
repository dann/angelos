package Angelos::Dispatcher::Routes::Builder;
use Moose;
use HTTP::Router::Route;
use Angelos::Dispatcher::Routes::Builder::Resource;
use Angelos::Dispatcher::Routes::Builder::Connect;

sub build {
    my ( $self, $appclass, $routes_conf ) = @_;
    my $routes = [];
    foreach my $route ( @{$routes_conf} ) {
        if ( $route->{type} eq 'connect' ) {
            push @{$routes},
                Angelos::Dispatcher::Routes::Builder::Connect->new->build(
                $route);
        }
        elsif ( $route->{type} eq 'resource' ) {
            foreach my $resource_route (
                @{ Angelos::Dispatcher::Routes::Builder::Resource->new->build(
                        $route)
                }
                )
            {
                push @{$routes}, $resource_route;
            }

        }
        elsif ( $route->{type} eq 'resources' ) {
            die 'NotSupported';
        }
    }
    $routes;
}

1;

package Angelos::Dispatcher::Routes::Builder;
use Moose;
use HTTP::Router::Route;
use String::CamelCase qw(camelize);

sub build {
    my ( $self, $appclass, $routes_conf ) = @_;
    my $routes = [];
    foreach my $route ( @{$routes_conf} ) {
        if ( $route->{type} eq 'connect' ) {
            push @{$routes}, $self->build_connect_route( $appclass, $route );
        }
        elsif ( $route->{type} eq 'resource' ) {
            push @{$routes}, $self->build_resource_route($appclass, $route);
        }
        elsif ( $route->{type} eq 'resources' ) {
            die 'NotSupported';
        }
    }
    $routes;
}

sub build_connect_route {
    my ( $self, $appclass, $route ) = @_;
    my $args = {};
    $args->{action} = $route->{action};
    $args->{controller}= camelize( $route->{controller} );
    $args->{conditions}   = $route->{conditions}   || {};
    $args->{requirements} = $route->{requirements} || {};

    $self->_build_route( $route->{path} => $args );
}

# FIXME Implement later
sub build_resource_route {
    my ( $self, $appclass, $route ) = @_;
    my $path = '/' . $route->{controller};
    my $args = {};
    $args->{controller}=camelize( $route->{controller} );
    $args->{conditions}   = {};
    $args->{requirements} = {};

    $self->_build_route( $path => $args );
}

sub _build_resource_path {
    my ( $self, $router, $route ) = @_;
    return '/' . $route->{controller} . '/' . $route->{action};
}

sub _build_route {
    my ( $self, $path, $args ) = @_;

    $args ||= {};
    my $conditions   = delete $args->{conditions}   || {};
    my $requirements = delete $args->{requirements} || {};

    return HTTP::Router::Route->new(
        path         => $path,
        params       => $args,
        conditions   => $conditions,
        requirements => $requirements,
    );
}

1;

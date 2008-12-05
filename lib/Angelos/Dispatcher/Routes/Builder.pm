package Angelos::Dispatcher::Routes::Builder;
use Mouse;
use HTTP::Router::Route;
use Angelos::Dispatcher::Routes::Builder::Resource;
use Angelos::Dispatcher::Routes::Builder::Connect;

has 'connect_builder' => (
    is      => 'rw',
    default => sub {
        Angelos::Dispatcher::Routes::Builder::Connect->new;
    }
);

has 'resource_builder' => (
    is      => 'rw',
    default => sub {
        Angelos::Dispatcher::Routes::Builder::Resource->new;
    }
);

no Mouse;

sub build {
    my ( $self, $appclass, $routes_conf ) = @_;
    my $routes = [];
    foreach my $route ( @{$routes_conf} ) {
        if ( $route->{type} eq 'connect' ) {
            push @{$routes}, $self->connect_builder->build($route);
        }
        elsif ( $route->{type} eq 'resource' ) {
            push @{$routes}, @{ $self->resource_builder->build($route) };
        }
        elsif ( $route->{type} eq 'resources' ) {
            die 'NotSupported';
        }
    }
    $routes;
}

__PACKAGE__->meta->make_immutable;

1;

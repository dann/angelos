package Angelos::PSGI::ServerGatewayBuilder;
use strict;
use warnings;
use Plack::Loader;

sub build {
    my ( $class, $module, $args ) = @_;
    my $server_gateway = Plack::Loader->load( $module, %{$args} );
    $server_gateway;
}

1;


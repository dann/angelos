package Angelos::Types;
use Mouse;
use Angelos::PSGI::ServerGatewayBuilder;
use MouseX::Types - declare => [
    qw(
        ServerGateway
        )
];
use MouseX::Types::Mouse qw(HashRef);

subtype ServerGateway;

coerce ServerGateway, from HashRef, via {
    my $module = $_->{module};
    my $args   = $_->{args};
    my $server = Angelos::PSGI::ServerGatewayBuilder->build( $module, $args );
    return $server;
};

1;

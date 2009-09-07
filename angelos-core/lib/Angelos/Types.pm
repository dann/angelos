package Angelos::Types;
use Mouse;
use Angelos::PSGI::ServerGatewayBuilder;
use MouseX::Types - declare => [
    qw(
        Interface
        )
];
use MouseX::Types::Mouse qw(HashRef);

subtype Interface;

coerce Interface, from HashRef, via {
    my $module = $_->{module};
    my $args   = $_->{args};
    $args->{psgi_handler} = $_->{psgi_handler};

    use Data::Dumper;
    warn $module;
    warn Dumper $args;
    my $server = Angelos::PSGI::ServerGatewayBuilder->build( $module, $args );
    return $server;
};

1;

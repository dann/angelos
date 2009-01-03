use strict;
use warnings;
use Test::TCP;
use HTTP::Engine;
use LWP::UserAgent;
use Mouse;
use HTTP::Engine::Response;

my $port = 3000;

HTTP::Engine->new(
    interface => {
        module          => 'ServerSimple',
        args            => { port => $port, },
        request_handler => sub {
            my $req = shift;
            HTTP::Engine::Response->new( status => 200, body => 'ok' );
        },
    },
)->run;


package TestModPerl::HTTPEngine;
use Mouse;
extends 'HTTP::Engine::Interface::ModPerl';
use HTTP::Engine;
use HTTP::Engine::Response;

no Mouse;

sub create_engine {
    my ( $class, $r, $context_key ) = @_;

    HTTP::Engine->new(
        interface => {
            module          => 'ModPerl',
            request_handler => sub {
                HTTP::Engine::Response->new(
                    status => 200,
                    body   => 'HelloWorld',
                );
            }
        },
    );
}

__PACKAGE__->meta->make_immutable;

1;

package TestModPerl::HTTPEngine;
use Mouse;
use HTTP::Engine;
use HTTP::Engine::Response;

__PACKAGE__->meta->make_immutable;

no Mouse;

sub setup_engine {
    my ( $self, $conf ) = @_;
    $conf->{request_handler} = sub { $self->handle_request(@_) };
    HTTP::Engine->new( interface => $conf, );
}

sub handle_request {
    my ( $self, $req ) = @_;
    HTTP::Engine::Response->new(
        status => 200,
        body   => 'HelloWorld',
    );
}

1;

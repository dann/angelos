package Angelos::Dispatcher::Routes;

use Moose;
use HTTP::Router;
use Angelos::Dispatcher::Dispatch::Routes;

has 'dispatcher' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
);

no Moose;

sub dispatch {
    my ( $self, $req ) = @_;
    warn $req->path;
    my $match
        = $self->dispatcher->match( $req->path, { method => $req->method } );
    my $dispatch
        = Angelos::Dispatcher::Dispatch::Routes->new( match => $match );
    return $dispatch;
}

__PACKAGE__->meta->make_immutable;

1;

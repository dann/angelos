package Angelos::Dispatcher;
use Mouse;
use HTTP::Router;
use Angelos::Dispatcher::Dispatch;

has 'dispatcher' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
    handles => [qw(add_route)],
);

no Mouse;

sub dispatch {
    my ( $self, $req ) = @_;
    my $match
        = $self->dispatcher->match( $req->path, { method => $req->method } );
    my $dispatch = Angelos::Dispatcher::Dispatch->new( match => $match );
    return $dispatch;
}

__PACKAGE__->meta->make_immutable;

1;

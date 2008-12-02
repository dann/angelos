package Angelos::Dispatcher::PathDispatcher;
use Moose;
use Path::Dispatcher;

has 'dispatcher' => (
    is      => 'ro',
    default => sub {
        Path::Dispatcher->new;
    }
);

no Moose;

sub match {
    my ( $self, $req ) = @_;
    my $dispatch = $self->dispatcher->dispatch( $req->path );
    return $dispatch;
}

__PACKAGE__->meta->make_immutable;

1;

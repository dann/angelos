package Angelos::PSGI::Engine;
use Mouse;
use Angelos::Types qw( ServerGateway );

has 'interface' => (
    is     => 'ro',
    isa    => ServerGateway,
    coerce => 1,
);

has 'psgi_handler' => ( is => 'rw', );

sub run {
    my $self = shift;
    $self->interface->run( $self->psgi_handler );
}

__PACKAGE__->meta->make_immutable( inline_destructor => 1 );
1;


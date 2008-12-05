package Angelos::View::Engine;
use Mouse;
use Carp();

has 'engine' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_engine',
);

no Mouse;

sub render {
    my ( $self, $c, $vars ) = @_;
    Carp::croak('sub class must implement this method!!!');
}

__PACKAGE__->meta->make_immutable;

1;

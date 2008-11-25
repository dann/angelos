package Angelos::View::Engine;
use Moose;

has 'engine' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_engine',
);

no Moose;

sub render {
    my ( $self, $template, $stash, $args ) = @_;
    die 'Implement me';
}

__PACKAGE__->meta->make_immutable;

1;

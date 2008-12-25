package Angelos::Middleware;
use Mouse;

no Mouse;

sub wrap {
    my $self = shift;
    die 'Implement me';
}

__PACKAGE__->meta->make_immutable;

1;

package Angelos::Middleware;
use Mouse;

has 'handler' => (
    is => 'rw',
);

sub wrap {
    my $self = shift;
    die 'Implement me';
}

1;

package Angelos::Logger;
use Moose;

has 'path' => (
    is => 'rw',
    default => sub {
        my $self = shift;
        Angelos::Home->path_to('log', $self->mode . ".log");
    },
);

has 'mode' => (
    is => 'rw',
    default => sub {
        'debug';
    }
);

no Moose;

sub log {
    my ( $self, $message, $level ) = @_;
    my $logger = Angelos::Logger::Factory->create;
    $level = $level || 'debug';
    eval { $logger->$level($message); };
}

__PACKAGE__->meta->make_immutable;

1;

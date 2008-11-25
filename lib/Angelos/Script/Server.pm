package Angelos::Script::Server;
use Moose;
use MooseX::Types::Path::Class qw(File Dir);
use Angelos;
use Pod::Usage;
use Path::Class;
use Angelos::Utils;

with 'Angelos::Config';

extends 'Angelos::Script';

has 'root' => (
    traits      => ['Getopt'],
    cmd_aliases => 'r',
    is          => 'rw',
    isa         => Dir,
    required    => 1,
    coerce      => 1,
    default     => sub { Angelos::Utils->path_to('root')->absolute },
);

has 'host' => (
    traits      => ['Getopt'],
    cmd_aliases => 'h',
    is          => 'rw',
    isa         => 'Str',
    default     => 0,
);

has 'server' => (
    traits      => ['Getopt'],
    cmd_aliases => 's',
    is          => 'rw',
    isa         => 'Str',
    default     => 'ServerSimple',
);

has 'port' => (
    traits      => ['Getopt'],
    cmd_aliases => 'p',
    is          => 'rw',
    isa         => 'Int',
    default     => 3000,
    required    => 1,
);

has 'help' => (
    traits      => ['Getopt'],
    cmd_aliases => 'h',
    is          => 'rw',
    isa         => 'Bool',
    default     => 0
);

no Moose;

sub run {
    my $self = shift;
    if ( $self->help ) {
        pod2usage(
            -input   => ( caller(0) )[1],
            -exitval => 1,
        );
    }
    Angelos->new(
        host   => $self->host,
        port   => $self->port,
        root   => $self->root,
        server => $self->server,
    );
}

__PACKAGE__->meta->make_immutable;

1;

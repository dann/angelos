package Angelos::Script::Server;
use Moose;
use MooseX::Types::Path::Class qw(File Dir);
use Angelos;
use Pod::Usage;
use Path::Class;

with 'Angelos::Config';

extends 'Angelos::Script';

has 'root' => (
    traits      => ['Getopt'],
    cmd_aliases => 'r',
    is          => 'rw',
    isa         => Dir,
    required    => 1,
    coerce      => 1,
    default     => sub { Path::Class::Dir->new('root')->absolute },
);

has 'host' => (
    traits      => ['Getopt'],
    cmd_aliases => 'h',
    is          => 'rw',
    isa         => 'Str',
    default     => 0,
);

has 'engine' => (
    traits      => ['Getopt'],
    cmd_aliases => 'e',
    is          => 'rw',
    isa         => 'Str',
    default     => 'ServerSimple',
);

has 'port' => (
    traits      => ['Getopt'],
    cmd_aliases => 'p',
    is          => 'rw',
    isa         => 'Int',
    default     => 10070,
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
        engine => $self->engine,
    );
}

__PACKAGE__->meta->make_immutable;

1;

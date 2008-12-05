package Angelos::Script::Server;
use Mouse;
use Angelos;
use Pod::Usage;
use Path::Class;
use Angelos::Home;
use UNIVERSAL::require;

extends 'Angelos::Script';

has 'app' => (
    is          => 'rw',
    required    => 1,
);

has 'root' => (
    is          => 'rw',
    required    => 1,
    default     => sub { Angelos::Home->path_to('root')->absolute },
);

has 'host' => (
    is          => 'rw',
    default     => 0,
);

has 'server' => (
    is          => 'rw',
    default     => 'ServerSimple',
);

has 'port' => (
    is          => 'rw',
    default     => 3000,
    required    => 1,
);

has 'help' => (
    is          => 'rw',
    default     => 0
);

no Mouse;

sub run {
    my $self = shift;
    if ( $self->help ) {
        pod2usage(
            -input   => ( caller(0) )[1],
            -exitval => 1,
        );
    }

    $self->app->require;
    $self->app->new(
        host   => $self->host,
        port   => $self->port,
        root   => $self->root,
        server => $self->server,
    )->run;
}

__PACKAGE__->meta->make_immutable;

1;

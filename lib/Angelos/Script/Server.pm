package Angelos::Script::Server;
use Mouse;
use Pod::Usage;
use UNIVERSAL::require;
use Angelos::Home;

with 'MouseX::Getopt';

has 'root' => (
    is       => 'rw',
    required => 1,
    default  => sub { Angelos::Home->path_to( 'share', 'root' )->absolute },
);

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'server' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'ServerSimple',
);

has 'port' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 3000,
    required => 1,
);

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

has 'app' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'help' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

no Mouse;

sub run {
    my $self = shift;
    if ( $self->help ) {
        pod2usage(2);
    }
    my $app_name = $self->app;
    $app_name->require;
    my $app = $app_name->new(
        host   => $self->host,
        port   => $self->port,
        root   => $self->root,
        server => $self->server,
        debug  => $self->debug,
    );
    $app->setup;
    $app->run;
}

__PACKAGE__->meta->make_immutable;

1;

__END__



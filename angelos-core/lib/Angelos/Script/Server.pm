package Angelos::Script::Server;
use Angelos::Class;
use Pod::Usage;
use UNIVERSAL::require;

with 'MouseX::Getopt';

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

has 'env' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'development',
);

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
        server => $self->server,
        debug  => $self->debug,
    );
    $app->run;
}

__END_OF_CLASS__

__END__



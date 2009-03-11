package Angelos::Script::Server;
use Angelos::Class;
use Pod::Usage;
use UNIVERSAL::require;

with 'MouseX::Getopt';

has 'host' => (
    metaclass => 'Getopt',
    is      => 'rw',
    isa     => 'Str',
    default => 0,
    cmd_aliases => [qw(h)],
);

has 'server' => (
    metaclass => 'Getopt',
    is      => 'rw',
    isa     => 'Str',
    default => 'ServerSimple',
    cmd_aliases => [qw(s)],
);

has 'port' => (
    metaclass => 'Getopt',
    is       => 'rw',
    isa      => 'Int',
    default  => 3000,
    required => 1,
    cmd_aliases => [qw(h)],
);

has 'debug' => (
    metaclass => 'Getopt',
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
    cmd_aliases => [qw(d)],
);

has 'app' => (
    metaclass => 'Getopt',
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'help' => (
    metaclass => 'Getopt',
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
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



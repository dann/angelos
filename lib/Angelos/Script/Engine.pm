package Angelos::Script::Engine;
use base qw(App::CLI::Command);
use Mouse;
use Angelos;
use Pod::Usage;
use Path::Class;
use Angelos::Home;
use UNIVERSAL::require;

=head1 NAME

Angelos::Script::Server - A server script engine

=head1 DESCRIPTION

=head1 METHODS

=head2 options()

=cut

sub options { }

has 'app' => (
    is          => 'rw',
    required    => 1,
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
    my $app = $self->app->new(
        host   => $self->host,
        port   => $self->port,
#        root   => $self->root,
        server => $self->server,
    );
    $app->setup; 
    $app->run;
}

__PACKAGE__->meta->make_immutable;

1;

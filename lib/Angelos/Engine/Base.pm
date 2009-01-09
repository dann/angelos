package Angelos::Engine::Base;
use Mouse;
use Carp ();
use HTTP::Engine;
use Angelos::Home;
use Angelos::Logger;
use Angelos::Exceptions;
use Angelos::Logger;

has 'engine' => (
    is      => 'rw',
    isa     => 'HTTP::Engine',
    handles => [qw(run)],
);

has 'root' => (
    is       => 'rw',
    required => 1,
    default  => sub { Angelos::Home->path_to( 'share', 'root' )->absolute },
);

has 'host' => (
    is  => 'rw',
    isa => 'Str',
);

has 'port' => (
    is  => 'rw',
    isa => 'Int',
);

has 'server' => (
    is      => 'rw',
    default => 'ServerSimple',
);

has 'logger' => (
    is      => 'rw',
    handles => [qw(log)],
);

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

no Mouse;

sub BUILD {
    my $self = shift;
    $self->engine( $self->build_engine );
}

sub SETUP { }

sub build_engine {
    my $self            = shift;
    my $request_handler = $self->build_request_handler;

    return HTTP::Engine->new(
        interface => {
            module => $self->server,
            args   => {
                host => $self->host,
                port => $self->port,
                root => $self->root,
            },
            request_handler => $request_handler,
        },
    );
}

sub build_request_handler {
    my $self = shift;
    my $request_handler
        = sub { my $req = shift; $self->handle_request($req) };
    $request_handler;
}

sub handle_request {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must overried this method' );
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

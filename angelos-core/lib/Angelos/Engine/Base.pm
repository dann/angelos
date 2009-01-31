package Angelos::Engine::Base;
use Angelos::Class;
use Carp ();
use HTTP::Engine;
use Angelos::Home;
use Angelos::Exceptions;

with 'Angelos::Class::Loggable';

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
    is      => 'rw',
    isa     => 'Str',
    default => '127.0.0.1',
);

has 'port' => (
    is      => 'rw',
    isa     => 'Int',
    default => 3000,
);

has 'server' => (
    is      => 'rw',
    default => 'ServerSimple',
);

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

has 'request_handler' => (
    is  => 'rw',
    isa => 'CodeRef',
);

sub BUILD {
    my $self = shift;
    $self->engine( $self->build_engine );
}

sub SETUP { }

sub build_engine {
    my $self            = shift;
    my $request_handler = $self->request_handler;
    $request_handler ||= $self->build_request_handler;

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

__END_OF_CLASS__

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

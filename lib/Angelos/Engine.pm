package Angelos::Engine;
use Mouse;
use Carp         ();
use Scalar::Util ();
use HTTP::Engine;
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Context;
use Angelos::Component::Loader;
use Angelos::Home;
use Angelos::Logger;
use Angelos::Middleware::Builder;
use Angelos::Exceptions;
use Angelos::Logger;

with 'Angelos::Class::Pluggable';

has 'engine' => (
    is      => 'rw',
    isa     => 'HTTP::Engine',
    lazy    => 1,
    builder => 'build_engine',
    handles => [qw(run)],
);

has 'dispatcher' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_dispathcer',
    handles => [qw(set_routeset uri_for)],
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

has 'component_loader' => (
    is      => 'rw',
    default => sub {
        Angelos::Component::Loader->new;
    },
    handles => {
        'controller' => 'search_controller',
        'model'      => 'search_model',
        'view'       => 'search_view',
    }
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
    $self->SETUP;
}

sub SETUP { }

sub build_engine {
    my $self            = shift;
    my $request_handler = $self->_build_request_handler;

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

sub _build_request_handler {
    my $self            = shift;
    my $request_handler = eval {
        Angelos::Middleware::Builder->build(
            sub { my $req = shift; $self->handle_request($req) } );
    };
    $request_handler;
}

sub build_dispathcer {
    my $self = shift;
    return Angelos::Dispatcher->new;
}

sub handle_request {
    my ( $self, $req ) = @_;
    my $res = HTTP::Engine::Response->new;
    my $c   = Angelos::Context->new(
        request  => $req,
        response => $res,
        app      => $self
    );

    eval { $self->DISPATCH( $c, $req ); };
    if ( my $e = $@ ) {
        $self->HANDLE_EXCEPTION( $c, $e );
    }
    return $c->res;
}

sub DISPATCH {
    my ( $self, $c, $req ) = @_;
    my $dispatch = $self->dispatcher->dispatch($req);

    unless ( $dispatch->has_matches ) {
        $self->logger->log( level => 'info', message => '404 Not Found' );
        $c->res->status(404);
        $c->res->body("404 Not Found");
        return $c->res;
    }
    $dispatch->run($c);
    $c->res;
}

sub HANDLE_EXCEPTION {
    my ( $self, $c, $error ) = @_;
    $self->logger->log( level => 'error', message => $error );
    $c->res->content_type('text/html; charset=utf-8');
    $c->res->status(500);
    $c->res->body( 'Internal Error:' . $error );
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

package Angelos::Engine;
use Angelos::Class;
use Carp         ();
use Scalar::Util ();
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Middleware::Builder;
use Angelos::Exceptions;
use Exception::Class;
use Angelos::Component::Loader;
use Angelos::Utils;

with 'Angelos::Class::Pluggable';
extends 'Angelos::Engine::Base';

has 'dispatcher' => (
    is      => 'rw',
    default => sub {
        shift->build_dispatcher;
    },
    handles => [qw(set_routeset forward detach)],
);

has 'component_manager' => (
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

sub build_request_handler {
    my $self            = shift;
    my $request_handler = Angelos::Middleware::Builder->new->build(
        sub { my $req = shift; $self->handle_request($req) } );
    $request_handler;
}

sub build_dispatcher {
    my $self = shift;
    return Angelos::Dispatcher->new;
}

sub handle_request {
    my ( $self, $req ) = @_;
    my $res = HTTP::Engine::Response->new;

    my $c = $self->create_context( $req, $res );
    no warnings 'redefine';
    local *Angelos::Registrar::context = sub {$c};

    eval { $self->DISPATCH($req); };
    if ( my $e = Exception::Class->caught() ) {
        $self->HANDLE_EXCEPTION($e);
    }

    return $c->res;
}

sub create_context {
    my ( $self, $request, $response ) = @_;
    my $c = $self->app;
    $c->request($request);
    $c->response($response);
    $c;
}

sub DISPATCH {
    my ( $self, $req ) = @_;
    my $dispatch = $self->dispatcher->dispatch($req);

    my $c = $self->context;
    unless ( $dispatch->has_matches ) {
        $self->log->info( "404 Not Found. path: " . $req->path );
        $c->res->status(404);
        $c->res->body("404 Not Found.");
        return $c->res;
    }
    $dispatch->run;
    $c->res;
}

sub HANDLE_EXCEPTION {
    my ( $self, $error ) = @_;
    $self->log->error( "404 Not Found. path: " . $error );

    my $c = $self->context;
    $c->res->content_type('text/html; charset=utf-8');
    $c->res->status(500);
    $c->res->body( 'Internal Error:' . $error );
}

sub context {
    Angelos::Utils::context();
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

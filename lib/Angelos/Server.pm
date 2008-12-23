package Angelos::Server;
use Angelos::Logger;
use Mouse;
use HTTP::Engine;
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Context;
use Angelos::Component::Loader;
use Angelos::Home;
use Angelos::Logger;
use Angelos::RequestHandler::Builder;
use Carp ();

with( 'MouseX::Plaggerize', );

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
    handles => [qw(add_route uri_for)],
);

has 'root' => (
    is       => 'rw',
    required => 1,
    default  => sub { Angelos::Home->path_to('root')->absolute },
);

has 'host' => (
    is      => 'rw',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    default  => 3000,
    required => 1,
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

around 'new' => sub {
    my ( $next, $class, @args ) = @_;
    my $instance = $next->( $class, @args );
    $instance->run_hook('AFTER_INIT');
    return $instance;
};

no Mouse;

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
        Angelos::RequestHandler::Builder->build(
            sub { my $req = shift; $self->handle_request($req) } );
    };
    if ( my $err = $@ ) {

        # FIXME warn error if error occurs in builder.
        warn $err;
        Carp::croak $err;
    }
    $request_handler;
}

sub build_dispathcer {
    my $self = shift;
    return Angelos::Dispatcher->new;
}

sub handle_request {
    my ( $self, $req ) = @_;
    my $path = $req->path;
    my $res  = HTTP::Engine::Response->new;
    my $c    = Angelos::Context->new(
        request  => $req,
        response => $res,
        app      => $self
    );

    eval {
        $self->run_hook( 'BEFORE_DISPATCH', $c );
        $self->dispatch( $c, $req );
        $self->run_hook( 'AFTER_DISPATCH', $c );
    };
    $self->handle_exception( $c, $@ ) if $@;
    return $c->res;

}

sub dispatch {
    my ( $self, $c, $req ) = @_;
    my $dispatch = $self->dispatcher->dispatch($req);
    unless ( $dispatch->has_matches ) {
        $c->res->status(404);
        $c->res->body("404 Not Found");
        return $c->res;
    }
    $dispatch->run($c);
    $c->res;
}

sub handle_exception {
    my ( $self, $c, $error ) = @_;
    $c->res->status(500);
    $c->res->body( "Internal Server Error:" . $error ) unless $c->res->body;
}

__PACKAGE__->meta->make_immutable;

1;

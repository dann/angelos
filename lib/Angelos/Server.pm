package Angelos::Server;
use Moose;
use MooseX::Types::Path::Class qw(File Dir);
use HTTP::Engine;
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Context;
use Angelos::Component::Loader;
use Angelos::Utils;

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
);

has 'root' => (
    is       => 'rw',
    isa      => Dir,
    required => 1,
    coerce   => 1,
    default  => sub { Angelos::Utils->path_to('root')->absolute },
);

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 3000,
    required => 1,
);

has 'server' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'ServerSimple',
);

no Moose;

sub build_engine {
    my $self = shift;

    return HTTP::Engine->new(
        interface => {
            module => $self->server,
            args   => {
                host => $self->host,
                port => $self->port,
                root => $self->root,
            },
            request_handler => sub { $self->handle_request(@_) },
        },
    );
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

    my $dispatch = $self->dispatcher->dispatch($path);
    unless ( $dispatch->has_matches ) {
        $c->res->status(404);
        $c->res->body("404 Not Found");
        return $c->res;
    }
    eval { $dispatch->run($c); };

    if ($@) {
        $c->res->status(500);
        $c->res->body("Internal Server Error");
        return $c->res;
    }

    return $c->res;
}

sub view {
    my ( $self, $view ) = @_;

    # FIXME: from component loader
}

sub model {
    my ( $self, $model ) = @_;

    # FIXME: from component loader
}

sub controller {
    my ( $self, $controller ) = @_;

    # FIXME: from component loader
}

__PACKAGE__->meta->make_immutable;

1;

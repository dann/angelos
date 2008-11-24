package Angelos::Engine;
use Moose;
use HTTP::Engine;
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Context;

has 'conf' => ( is => 'rw', );

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

has 'views' => (
    is   => 'rw',
    lazy => 1,
);

no Moose;

sub build_engine {
    my $self = shift;
    return HTTP::Engine->new(
        interface => {
            module          => 'ServerSimple',
            args            => $self->conf,
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
    my $c = Angelos::Context->new( req => $req, res => $res, app => $self );

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
    $self->views->{$view};
}

__PACKAGE__->meta->make_immutable;

1;

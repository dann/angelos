package Angelos::Engine;
use Moose;
use HTTP::Engine;
use HTTP::Engine::Response;
use Angelos::Dispatcher;
use Angelos::Context;
use Angelos::Loader;
use MooseX::Types::Path::Class qw(File Dir);

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

has 'conf' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    isa      => Dir,
    required => 1,
    coerce   => 1,
    default  => sub { Path::Class::Dir->new('root')->absolute },
);

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 10070,
    required => 1,
);

has 'engine' => (
    cmd_aliases => 'h',
    is          => 'rw',
    isa         => 'Str',
    default     => 'ServerSimple',
);

has 'views' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_views',
);

has 'models' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_models',
);

has 'controllers' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_controllers',
);

no Moose;

sub build_engine {
    my $self = shift;
    return HTTP::Engine->new(
        interface => {
            module          => $self->engine,
            args            => $self->conf,
            request_handler => sub { $self->handle_request(@_) },
        },
    );
}

sub build_dispathcer {
    my $self = shift;
    return Angelos::Dispatcher->new;
}

sub build_views {
    my $self  = shift;
    my $views = Angelos::Loader->new->load_views;
    $views;
}

sub build_models {
    my $self   = shift;
    my $models = Angelos::Loader->new->load_models;
    $models;
}

sub build_controllers {
    my $self        = shift;
    my $controllers = Angelos::Loader->new->load_controllers;
    $controllers;
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
    $self->views->{$view};
}

sub model {
    my ( $self, $model ) = @_;
    $self->models->{$model};
}

sub controller {
    my ( $self, $controller ) = @_;
    $self->controllers->{$controller};
}

__PACKAGE__->meta->make_immutable;

1;

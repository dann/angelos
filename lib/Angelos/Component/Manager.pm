package Angelos::Component::Manager;
use Moose;
use Angelos::Component::Loader;
use Angelos::Component::Resolver;

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

has 'resolver' => (
    is      => 'rw',
    default => sub {
        Angelos::Component::Resolver->new;
    }
);

no Moose;

sub build_views {
    my $self  = shift;
    my $views = Angelos::Component::Loader->new->load_views;
    $views;
}

sub build_models {
    my $self   = shift;
    my $models = Angelos::Component::Loader->new->load_models;
    $models;
}

sub build_controllers {
    my $self        = shift;
    my $controllers = Angelos::Component::Loader->new->load_controllers;
    $controllers;
}

sub controller {
    my ( $self, $controller ) = @_;
    $controller = $self->resolver->reslove_component_name($controller);
    $self->controllers->{$controller};
}

sub model {
    my ( $self, $model ) = @_;
    $model = $self->reslover->resolve_component_name($model);
    $self->models->{$model};
}

sub view {
    my ( $self, $view ) = @_;
    $view = $self->reslover->reslove_view_engine_name($view);
    $self->views->{$view};
}

__PACKAGE__->meta->make_immutable;

1;

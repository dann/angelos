package Angelos::Class::ComponentLoadable;
use Mouse::Role;
use Angelos::Component::Loader;

has '__component_loader' => (
    is      => 'rw',
    lazy    => 1,
    builder => '__build_component_loader',
    handles => {
        'controller' => 'search_controller',
        'model'      => 'search_model',
        'view'       => 'search_view',
    }
);

sub __build_component_loader {
    Angelos::Component::Loader->new;
}

1;

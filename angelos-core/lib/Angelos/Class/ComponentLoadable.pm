package Angelos::Class::ComponentLoadable;
use Angelos::Role;
use Angelos::Registrar;

has '__component_loader' => (
    is      => 'rw',
    lazy    => 1,
    builder => '__build_component_loader',
    handles => {
        'controller'    => 'search_controller',
        'model'         => 'search_model',
        'view'          => 'search_view',
        'set_component' => 'set_component',
        'get_component' => 'get_component',
    }
);

sub __build_component_loader {
    Angelos::Registrar::context()->engine->component_loader;
}

1;

__END__

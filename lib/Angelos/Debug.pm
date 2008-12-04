package Angelos::Debug;
use Angelos::Debug::Routes;
use Angelos::Debug::Components;

sub is_debug_mode {
    $ENV{ANGELOS_DEBUG} ? 1 : 0;
}

sub show_dispatch_table {
    my ($class, $routes) = @_;
    Angelos::Debug::Routes->show_dispatch_table($routes);
}

sub show_components {
    my ($class, $components) = @_;
    Angelos::Debug::Components->show_components($components);
}

1;

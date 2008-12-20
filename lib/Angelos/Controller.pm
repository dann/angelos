package Angelos::Controller;

use Mouse;
with 'Angelos::Role::Pluggable';

has '_plugin_app_ns' => (
    +default => sub {
        'Angelos::Controller';
    }
);

no Mouse;

1;

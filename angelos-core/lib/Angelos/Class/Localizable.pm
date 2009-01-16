package Angelos::Class::Localizable;
use Mouse::Role;
use Angelos::I18N;

has 'localizer' => (
    is      => 'rw',
    default => sub {
        Angelos::I18N->instance;
    },
    handles => [qw(loc loc_lang)],
);

1;

package TestApp::Role::Localizable;
use Mouse::Role;
use TestApp::I18N;

has '__localizer' => (
    is => 'rw',
    default => sub {
        TestApp::I18N->instance;
    },
    handles => ['loc' ,'loc_lang'],
);

1;

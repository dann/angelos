package TestApp::Role::SchemaAware;
use Mouse::Role;

has 'schema' => (
    is      => 'rw',
    default => sub {
        TestApp::Schema->master;
    },
);

has 'slave_schema' => (
    is      => 'rw',
    default => sub {
        TestApp::Schema->slave;
    },
);

1;

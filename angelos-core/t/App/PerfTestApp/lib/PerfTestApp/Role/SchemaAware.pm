package PerfTestApp::Role::SchemaAware;
use Mouse::Role;

has 'schema' => (
    is      => 'rw',
    default => sub {
        PerfTestApp::Schema->master;
    },
);

has 'slave_schema' => (
    is      => 'rw',
    default => sub {
        PerfTestApp::Schema->slave;
    },
);

1;

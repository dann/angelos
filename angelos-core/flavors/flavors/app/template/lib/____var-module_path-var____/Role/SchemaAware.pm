package [% module %]::Role::SchemaAware;
use Mouse::Role;

has 'schema' => (
    is      => 'rw',
    default => sub {
        [% module %]::Schema->master;
    },
);

has 'slave_schema' => (
    is      => 'rw',
    default => sub {
        [% module %]::Schema->slave;
    },
);

1;

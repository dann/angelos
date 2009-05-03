package [% module %]::Service::Base::DBIC;
use Mouse;
use [% module %]::Schema;
use [% module %]::Cache;
with 'Angelos::Service::Role::DBIC';

has schema => (
    +default => sub {
        [% module %]::Schema->master;
    }
);

has 'cache' => (
    +default => sub {
        [% module %]::Cache->instance;
    }
);

1;

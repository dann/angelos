package TestApp::Service::Base::DBIC;
use Mouse;
use TestApp::Schema;
use TestApp::Cache;
with 'Angelos::Service::Role::DBIC';

has 'schema' => (
    +default => sub {
        TestApp::Schema->master;
    }
);

has 'cache' => (
    +default => sub {
        TestApp::Cache->instance;
    }
);

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

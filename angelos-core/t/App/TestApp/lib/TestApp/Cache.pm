package TestApp::Cache;
use strict;
use warnings;
use TestApp::Config;
use base 'Angelos::Cache';

sub config {
    TestApp::Config->instance->global('cache');
}

1;

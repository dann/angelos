package PerfTestApp::Cache;
use strict;
use warnings;
use PerfTestApp::Config;
use base 'Angelos::Cache';

sub config {
    PerfTestApp::Config->instance->global('cache') || { driver => 'Memory' };
}

1;

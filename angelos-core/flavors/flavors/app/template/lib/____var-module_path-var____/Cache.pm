package [% module %]::Cache;
use strict;
use warnings;
use [% module %]::Config;
use base 'Angelos::Cache';

sub config {
    [% module %]::Config->instance->global('cache');
}

1;

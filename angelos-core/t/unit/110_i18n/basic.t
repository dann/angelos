#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;

use lib File::Spec->catdir('t', 'lib');

AngelosTest->runtests;

package AngelosTest;
use strict;
use warnings;
use Test::Most;
use base qw(Test::Class);

sub use_test : Tests {
    use_ok 'Angelos';
}

1;

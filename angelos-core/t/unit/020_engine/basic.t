#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;

use lib File::Spec->catdir('t', 'lib');

AngelosTest->runtests;

package AngelosTest;
use strict;
use warnings;
use Angelos::Test;
use base qw(Angelos::Test::Class);

sub use_test : Tests {
    use_ok 'Angelos::Engine';
}

1;

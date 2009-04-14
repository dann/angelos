#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use lib 't/lib';

use TAP::Harness::JUnit;
my $harness = TAP::Harness::JUnit->new(
    {   xmlfile => 'TEST-RESULT.xml',
        merge   => 1,
    }
);

$harness->runtests(@ARGV);


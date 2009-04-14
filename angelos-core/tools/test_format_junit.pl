#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/../lib";

warn $FindBin::RealBin;

use TAP::Harness::JUnit;
my $harness = TAP::Harness::JUnit->new(
    {   xmlfile => 'TEST-RESULT.xml',
        merge   => 1,
    }
);

$harness->runtests(@ARGV);


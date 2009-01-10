package Angelos::Test::InternalOnly;
use Test::More;
use strict;
use warnings;

sub import {
    unless ( $ENV{ANGELOS_INTERNAL_TESTS} ) {
        plan skip_all => "internal test only";
    }
}

1;

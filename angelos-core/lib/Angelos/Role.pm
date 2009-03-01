package Angelos::Role;
use strict;
use warnings;
use Mouse::Role ();
use utf8;

sub import {
    utf8->import;
    goto &Mouse::Role::import;
}

1;

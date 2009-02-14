package Angelos::Role;
use strict;
use warnings;
use Mouse::Role ();

sub import {
    goto &Mouse::Role::import;
}

1;

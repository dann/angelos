package Angelos::Role;
use strict;
use warnings;
use Any::Moose '::Role';

sub import {
    if (Any::Moose::is_moose_loaded()) {
        goto &Moose::Role::import;
    }
    else {
        goto &Mouse::Role::import;
    }
}

1;

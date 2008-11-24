package Angelos::Controller::Plugin;
use strict;
use warnings;
use Angelos::Meta::Plugin;
use Moose::Role ();

sub import {
    my $target = caller;
    my $meta   = Angelos::Meta::Plugin->initialize($target);
    $meta->alias_method( 'meta' => sub {$meta} );
    goto &Moose::Role::import;
}

1;

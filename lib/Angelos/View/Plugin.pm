package Angelos::View::Plugin;
use strict;
use warnings;
use Angelos::Meta::Plugin;
use Mouse::Role ();

sub import {
    my $target = caller;
    my $meta   = Angelos::Meta::Plugin->initialize($target);
    $meta->alias_method( 'meta' => sub {$meta} );
    goto &Mouse::Role::import;
}

1;

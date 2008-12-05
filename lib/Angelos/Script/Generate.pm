package Angelos::Script::Generate;
use Mouse;
use Module::Setup;
extends 'Angelos::Script';
no Mouse;

sub run {
    # FIXME fix later
    my $options = {};
    Module::Setup->new( options => $options )->run;
}

1;

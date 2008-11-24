package Angelos::Script::Generate;
use Moose;
use Module::Setup;
extends 'Angelos::Script';
no Moose;

sub run {
    # FIXME fix later
    my $options = {};
    Module::Setup->new( options => $options )->run;
}

1;

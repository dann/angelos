package Angelos::Script::CLI::Command;
use Moose;
extends qw(MooseX::App::Cmd::Command);

with 'Angelos::Config';

no Moose;
__PACKAGE__->meta->make_immutable;

1;

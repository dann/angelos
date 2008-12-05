package Angelos::Script::CLI::Command;
use Mouse;
extends qw(MooseX::App::Cmd::Command);

with 'Angelos::Config';

no Mouse;
__PACKAGE__->meta->make_immutable;

1;

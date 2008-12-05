package Angelos::Script::CLI;
use Mouse;
extends qw(MooseX::App::Cmd);

no Mouse;

sub plugin_search_path {
    my $class = shift;
    "${class}::Command";
}

__PACKAGE__->meta->make_immutable;

1;

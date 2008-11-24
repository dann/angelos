package Angelos::CLI;
use Moose;
extends qw(MooseX::App::Cmd);

no Moose;

sub plugin_search_path {
    my $class = shift;
    "${class}::Command";
}

__PACKAGE__->meta->make_immutable;

1;

package Angelos::Script::Command;
use strict;
use warnings;
use IPC::System::Simple;
use base 'App::Cmd::Command';

sub system {
    my ($self, @args) = @_;
    IPC::System::Simple::systemx(@args);
}

sub capture {
    my ($self, @args) = @_;
    IPC::System::Simple::capturex(@args);
}

1;

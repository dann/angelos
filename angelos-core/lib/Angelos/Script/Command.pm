package Angelos::Script::Command;
use Mouse;
use IPC::System::Simple;
use base 'App::Cmd::Command';

with 'Angelos::Class::Configurable';
with 'Angelos::Class::Loggable';

sub system {
    my ($self, @args) = @_;
    IPC::System::Simple::systemx(@args);
}

sub capture {
    my ($self, @args) = @_;
    IPC::System::Simple::capturex(@args);
}

1;

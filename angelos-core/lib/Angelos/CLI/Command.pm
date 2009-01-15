package Angelos::CLI::Command;
use Mouse;
use IPC::System::Simple;
use Angelos::Config;
use base 'App::Cmd::Command';

with 'Angelos::Class::Configurable';

no Mouse;

sub system {
    my ($self, @args) = @_;
    IPC::System::Simple::systemx(@args);
}

sub capture {
    my ($self, @args) = @_;
    IPC::System::Simple::capturex(@args);
}

__PACKAGE__->meta->make_immutable;

1;

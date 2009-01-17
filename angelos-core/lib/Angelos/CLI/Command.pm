package Angelos::CLI::Command;
use Angelos::Class;
use IPC::System::Simple;
use base 'App::Cmd::Command';

with 'Angelos::Class::Configurable';
with 'Angelos::Class::Loggable';
with 'Angelos::Class::ComponentLoadable';

sub system {
    my ($self, @args) = @_;
    IPC::System::Simple::systemx(@args);
}

sub capture {
    my ($self, @args) = @_;
    IPC::System::Simple::capturex(@args);
}

__END_OF_CLASS__

__END__


package Angelos::Script::Command::Console;
use Angelos::Class;
use Angelos::Console;
use base qw(Angelos::Script::Command);

has 'console' => (
    is      => 'rw',
    default => sub {
        Angelos::Console->new;
    }
);

=head1 NAME

Angelos::Script::Command::Console - A console for your Angelos application

=head1 DESCRIPTION

This script aims for developing purpose (or maintaining, if possible).
With this script, you can say something like this to diagnose your
application:

    % bin/angelos console
    angelos> print 'Hello';

=head1 METHODS

=cut

sub opt_spec {
    return ();
}

=head2 run()

Creates a new console process.

=cut

sub run {
    my $self = shift;
    $self->console->run;
}

__END_OF_CLASS__

__END__

=head1 AUTHOR

=cut


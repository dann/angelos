package Angelos::Script::Command::Console;
use strict;
use warnings;
use base qw(App::Cmd::Command);

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

    my $term = new Term::ReadLine 'Angelos Console';
    my $OUT = $term->OUT || \*STDOUT;
    my $cxt = Devel::EvalContext->new;
    while (defined($_ = $term->readline("angelos> "))) {
        if (/\S/) {
            my $res = $cxt->run($_);
            warn $@ if $@;
            print $OUT $res, "\n" unless $@ || !defined($res);
            $term->addhistory($_);
        }
    }
}

1;

=head1 AUTHOR

=cut


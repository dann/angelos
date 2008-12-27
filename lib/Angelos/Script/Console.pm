package Angelos::Script::Console;
use strict;
use warnings;
use base qw/App::CLI::Command/;
use Devel::EvalContext;
use Term::ReadLine;

=head1 NAME

Angelos::Script::Console - A console for your Angelos application

=head1 DESCRIPTION

This script aims for developing purpose (or maintaining, if possible).
With this script, you can say something like this to diagnose your
application:

    % bin/angelos console
    angelos> my $foo = Jifty->app_class("Model", "StuffCollection")->new;
    angelos> $foo->unlimit; YAML::Dump($foo)

All Perl code are ok, since each lines of input are send to
C<eval()>.

=head1 METHODS

=head2 options()

Returns nothing. This script has no options now. Maybe it will have
some command lines options in the future.

=cut

sub options { }

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


package Angelos::Script;
use base qw(App::CLI);

=head1 NAME

Angelos::Script - Base class for all bin/angelos commands

=head1 METHODS

=head2 prepare

C<prepare> figures out which command to run. If the user wants
C<--help> give them help.

=cut

sub prepare {
    my $self = shift;
    if ($ARGV[0] =~ /--?h(elp)?/i) {
        $ARGV[0] = 'help';
    }
    elsif (!@ARGV) {
        if ( my $cmd = $ENV{'ANGELOS_COMMAND'} ) {
            unshift @ARGV, $cmd;
        }
        else {
            unshift @ARGV, 'help';
        }
    }
    return $self->SUPER::prepare(@_);
}

1;

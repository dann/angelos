package Angelos::Script;
use base qw(App::CLI);
use Angelos::Home;
use Cwd;
use Path::Class;

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
    Angelos::Home->set_home(getcwd);
    return $self->SUPER::prepare(@_);
}

1;

__END__


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

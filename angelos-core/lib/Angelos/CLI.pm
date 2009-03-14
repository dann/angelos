package Angelos::CLI;
use strict;
use warnings;
use base qw(App::Cmd);

=head1 NAME

Angelos::CLI - Base class for CLI tool

=head1 METHODS

=cut

sub plugin_search_path {
    my $class = shift;

    "${class}::Command";
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



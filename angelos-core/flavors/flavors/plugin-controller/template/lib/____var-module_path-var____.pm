package [% module %];
use Mouse;
extends 'Angelos';

our $VERSION = '0.01';

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

[% module %] -

=head1 SYNOPSIS

  use [% module %];

=head1 DESCRIPTION

[% module %] is

=head1 AUTHOR

[% config.author %] E<lt>[% config.email %]E<gt>

=head1 SEE ALSO

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/[% dist %]/trunk [% dist %]

[% module %] is Subversion repository is hosted at L<http://coderepos.org/share/>.
patches and collaborators are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package HTTP::Router::Routes;

use Moose;
use MooseX::AttributeHelpers;
use HTTP::Router::Route;

has 'routes' => (
    metaclass => 'Collection::Array',
    is        => 'rw',
    isa       => 'ArrayRef[HTTP::Router::Route]',
    default   => sub { [] },
    lazy      => 1,
    provides  => { elements => 'all', push => 'push' },
);

no Moose; __PACKAGE__->meta->make_immutable;

=head1 NAME

HTTP::Router::Routes

=head1 METHODS

=head2 all

=head2 push($route)

=head1 PROPERTIES

=head2 routes

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTTP::Router>, L<HTTP::Router::Route>

=cut

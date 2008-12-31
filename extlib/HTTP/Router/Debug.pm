package HTTP::Router::Debug;

use strict;
use warnings;
use Text::SimpleTable;

sub show_table {
    my ( $class, @routes ) = @_;
    my $report = $class->_make_table_report(\@routes);
    print $report . "\n";
}

sub _make_table_report {
    my ( $class, $routes ) = @_;
    my $t = Text::SimpleTable->new(
        [ 35, 'path' ],
        [ 10, 'method' ],
        [ 10, 'controller' ],
        [ 10, 'action' ]
    );
    foreach my $route ( @{$routes} ) {
        $t->row(
            $route->path,
            join( ',', @{ $route->conditions->{method} } ),
            $route->params->{controller},
            $route->params->{action}
        );
    }
    my $header = 'Routing Table:' . "\n";
    my $table = $t->draw;
    $header . $table . "\n";
}

1;

=head1 NAME

HTTP::Router::Debug

=head1 METHODS

=head2 show_table(@routes)

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTTP::Router>, L<Text::SimpleTable>

=cut

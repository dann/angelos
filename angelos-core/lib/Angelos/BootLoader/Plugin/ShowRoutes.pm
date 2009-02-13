package Angelos::BootLoader::Plugin::ShowRoutes;
use Angelos::Plugin;
use Text::SimpleTable;

around 'build_routeset' => sub {
    my ( $next, $self ) = @_;
    my $routes = $self->$next();
    $self->__show_dispatch_table($routes);
    return $routes;
};

sub __show_dispatch_table {
    my ( $self, $routes ) = @_;
    my $report = $self->__make_dispatch_table_report($routes);
    $self->logger->info($report);
}

sub __make_dispatch_table_report {
    my ( $self, $routes ) = @_;
    my $t = Text::SimpleTable->new(
        [ 50, 'path' ],
        [ 10, 'method' ],
        [ 10, 'controller' ],
        [ 10, 'action' ]
    );
    foreach my $route ( $routes->routes ) {

        # FIXME metdods
        my $methods = $route->conditions->{method};
        $t->row(
            $route->path, $methods,
            $route->params->{controller},
            $route->params->{action}
        );
    }
    my $header = 'Dispatch Table:' . "\n";
    my $table  = $t->draw;
    $header . $table . "\n";
}

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

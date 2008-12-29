package Angelos::Debug::Routes;
use Text::SimpleTable;
use Mouse::Role;

around 'build_routeset' => sub {
    my ( $next, $self ) = @_;
    my $routes = $self->$next();
    Angelos::Debug::Routes->__show_dispatch_table($routes);
    return $routes;
};

sub __show_dispatch_table {
    my ( $class, $routes ) = @_;
    my $report = $class->__make_dispatch_table_report($routes);
    print $report . "\n";
}

sub __make_dispatch_table_report {
    my ( $class, $routes ) = @_;
    my $t = Text::SimpleTable->new(
        [ 35, 'path' ],
        [ 10, 'method' ],
        [ 10, 'controller' ],
        [ 10, 'action' ]
    );
    foreach my $route ( $routes->all ) {
        # FIXME metdods 
        my $methods = $route->conditions->{method};
        $t->row(
            $route->path,
            $methods,
            $route->params->{controller},
            $route->params->{action}
        );
    }
    my $header = 'Dispatch Table:' . "\n";
    my $table  = $t->draw;
    $header . $table . "\n";
}

1;

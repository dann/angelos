package Angelos::Debug::Routes;
use Text::SimpleTable;

sub show_dispatch_table {
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
    my $header = '<< Dispatch Table >>' . "\n";
    my $table = $t->draw;
    $header . $table;
}

1;

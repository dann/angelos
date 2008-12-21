package Angelos::Debug::Components;
use Text::SimpleTable;

sub show_components {
    my ( $class, $components ) = @_;
    my $report = $class->_make_components_report($components);
    print $report . "\n";
}

sub _make_components_report {
    my ( $class, $components ) = @_;
    my $t = Text::SimpleTable->new( [ 63, 'Class' ] );
    for my $comp ( sort keys %{$components} ) {
        $t->row($comp);
    }
    "Loaded components:\n" . $t->draw . "\n";
}

1;

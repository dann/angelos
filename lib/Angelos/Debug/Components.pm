package Angelos::Debug::Components;
use Mouse::Role;
use Text::SimpleTable;

around 'setup_components' => sub {
    my ( $next, $self ) = @_;
    my $components = $self->$next();
    Angelos::Debug::Components->__show_components($components);
    return $components;
};

sub __show_components {
    my ( $class, $components ) = @_;
    my $report = $class->__make_components_report($components);
    print $report . "\n";
}

sub __make_components_report {
    my ( $class, $components ) = @_;
    my $t = Text::SimpleTable->new( [ 63, 'Class' ] );
    for my $comp ( sort keys %{$components} ) {
        $t->row($comp);
    }
    "Loaded components:\n" . $t->draw . "\n";
}

1;

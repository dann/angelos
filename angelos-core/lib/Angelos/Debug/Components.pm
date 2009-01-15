package Angelos::Debug::Components;
use Mouse::Role;
use Text::SimpleTable;
with 'Angelos::Debug';

around 'setup_components' => sub {
    my ( $next, $self ) = @_;
    my $components = $self->$next();
    $self->__show_components($components);
    return $components;
};

sub __show_components {
    my ( $self, $components ) = @_;
    my $report = $self->__make_components_report($components);
    $self->log( level => 'info', message => $report );
}

sub __make_components_report {
    my ( $self, $components ) = @_;
    my $t = Text::SimpleTable->new( [ 63, 'Class' ] );
    for my $comp ( sort keys %{$components} ) {
        $t->row($comp);
    }
    "Loaded components:\n" . $t->draw . "\n";
}

1;

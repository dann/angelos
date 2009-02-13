package Angelos::BootLoader::Plugin::ShowComponents;
use Angelos::Plugin;
use Text::SimpleTable;

around 'setup_components' => sub {
    my ( $next, $self ) = @_;
    my $components = $self->$next();
    $self->__show_components($components);
    return $components;
};

sub __show_components {
    my ( $self, $components ) = @_;
    my $report = $self->__make_components_report($components);
    $self->logger->info($report);
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

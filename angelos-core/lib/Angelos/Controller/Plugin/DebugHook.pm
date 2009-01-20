package Angelos::Controller::Plugin::DebugHook;
use Angelos::Plugin;

after 'SETUP' => sub {
    my $self = shift;
    warn $self->is_plugin_loaded('DebugHook');
    $self->log->info( "SETUP: class=" . ref $self );
};

before 'ACTION' => sub {
    my ( $self, $c, $action, $params ) = @_;
    $self->log->info("BEFORE ACTION: $action, $params");
};

after 'ACTION' => sub {
    my $self = shift;
    $self->log->info("AFTER ACTION");
};

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

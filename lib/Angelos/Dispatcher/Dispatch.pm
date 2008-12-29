package Angelos::Dispatcher::Dispatch;
use Mouse;
extends 'HTTP::Request::Dispatcher::Dispatch';

no Mouse;

sub find_controller_instance {
    my ( $self, $args ) = @_;
    my $controller = delete $args->{controller};
    my $c          = @{ $args->{args} }[0];
    $c->controller($controller);
}

sub execute_action {
    my ( $self, $args ) = @_;
    my $controller = $args->{controller};
    my $action     = $args->{action};
    my $params     = $args->{params};
    my $context    = @{ $args->{args} }[0];
    $controller->_do_action( $context, $action, $params );
}

__PACKAGE__->meta->make_immutable;

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

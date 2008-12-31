package Angelos::Dispatcher::Dispatch;
use Mouse;
use Carp ();

has 'match' => (
    is       => 'rw',
    required => 1,
);

no Mouse;

sub run {
    my $self = shift;
    my @args = @_;
    $self->dispatch( \@args );
}

sub dispatch {
    my ( $self, $args ) = @_;

    my $match      = $self->match;
    my $controller = $match->params->{controller};
    my $action     = $match->params->{action};
    my $params     = $match->params;

    my $instance = $self->find_controller_instance(
        {   controller => $controller,
            args       => $args
        }
    );
    $self->execute_action(
        {   controller => $instance,
            action     => $action,
            params     => $params,
            args       => $args
        }
    );

}

sub has_matches {
    my $self = shift;
    $self->match ? 1 : 0;
}

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

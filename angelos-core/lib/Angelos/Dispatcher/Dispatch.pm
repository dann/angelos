package Angelos::Dispatcher::Dispatch;
use Angelos::Class;
use Carp ();

has 'match' => (
    is       => 'rw',
    required => 1,
);

sub run {
    my ($self, $context)  = @_;
    $self->dispatch( $context );
}

sub dispatch {
    my ( $self, $context ) = @_;

    my $match      = $self->match;
    my $controller = $match->params->{controller};
    my $action     = $match->params->{action};
    my $params     = $match->params;
    $context->_match($match);

    my $controller_instance = $self->find_controller_instance(
        {
            context => $context,
            controller => $controller,
        }
    );
    $controller_instance->context($context);;
    $controller_instance->_do_action( $action, $params );
}

sub has_matches {
    my $self = shift;
    $self->match ? 1 : 0;
}

sub find_controller_instance {
    my ( $self, $args ) = @_;
    my $controller = delete $args->{controller};
    my $context    = $args->{context};
    $context->controller($controller);
}

__END_OF_CLASS__

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

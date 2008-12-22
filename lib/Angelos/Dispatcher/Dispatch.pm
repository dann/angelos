package Angelos::Dispatcher::Dispatch;
use Mouse;
extends 'Request::Dispatcher::Dispatch';

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
    eval { $controller->do_action($context, $action, $params); };
    if ($@) {
        Carp::croak "can't execute $action method: " . $@;
    }
}

__PACKAGE__->meta->make_immutable;

1;

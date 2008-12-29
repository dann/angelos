package HTTP::Request::Dispatcher::Dispatch;
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
    Carp::croak('sub class must implement this method !');
}

sub execute_action {
    Carp::croak('sub class must implement this method !');
}

__PACKAGE__->meta->make_immutable;

1;

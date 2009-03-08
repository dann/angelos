package Angelos::Dispatcher;
use Angelos::Class;
use Angelos::Utils;
use Angelos::Dispatcher::Dispatch;
use HTTP::Router;
use Carp ();
use Params::Validate qw(SCALAR HASHREF);
use Angelos::Exceptions;

has 'router' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
);

sub dispatch_class {
    'Angelos::Dispatcher::Dispatch';
}

sub dispatch {
    my ( $self, $request ) = @_;
    my $match = $self->router->match($request);
    my $dispatch = $self->dispatch_class->new( match => $match );
    return $dispatch;
}

sub set_routeset {
    my ( $self, $routeset ) = @_;
    $self->router->routeset($routeset);
}

sub forward {
    my $self       = shift;
    my %forward_to = Params::Validate::validate(
        @_,
        {   action     => 1,
            controller => { type => SCALAR },
            params     => { optional => 1, type => HASHREF },
        }
    );
    my $controller          = $forward_to{controller};
    my $controller_instance = $self->find_controller($controller);

    my $action = $forward_to{action};
    my $params = $forward_to{params};

    Carp::croak "No such action: $action" unless $controller_instance->can($action);
    $controller_instance->$action( $self, $params );
}

# forward with filters
sub full_forward {
    my $self       = shift;
    my %forward_to = Params::Validate::validate(
        @_,
        {   action     => 1,
            controller => { type => SCALAR },

            params => { optional => 1, type => HASHREF },
        }
    );
    my $controller          = $forward_to{controller};
    my $controller_instance = $self->find_controller($controller);
    my $action              = $forward_to{action};
    my $params              = $forward_to{params};

    Carp::croak "No such action: $action" unless $controller_instance->can($action);
    $controller_instance->_dispatch_action( $self, $action, $params );
}

sub find_controller {
    my ( $self, $controller ) = @_;
    my $short_controller_name
        = Angelos::Utils::class2classsuffix($controller);
    my $controller_instance
        = $self->context->controller($short_controller_name);
    $controller_instance->context($self->context);
    $controller_instance;
}

sub detach {
    my ( $self, %forward_to ) = @_;
    $self->forward(%forward_to);
    Angelos::Exception::Detach->throw( message => 'DETACH' );
}

# detach with filters
sub full_detach {
    my ( $self, %forward_to ) = @_;
    $self->forward_with_filters(%forward_to);
    Angelos::Exception::Detach->throw( message => 'DETACH' );
}

sub context {
    Angelos::Utils::context();
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

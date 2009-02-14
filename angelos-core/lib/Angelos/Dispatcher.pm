package Angelos::Dispatcher;
use Angelos::Class;
use Angelos::Utils;
use Angelos::Dispatcher::Dispatch;
use HTTP::Router;
use Params::Validate qw(SCALAR HASHREF);
use Angelos::Exceptions;

has 'router' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
);

has 'app' => ( is => 'rw', );

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
    my $controller ||= $forward_to{controller};
    $controller    ||= caller;
    my $short_controller_name
        = Angelos::Utils::class2classsuffix($controller);
    my $controller_instance = $self->app->controller($short_controller_name);
    my $action              = $forward_to{action};
    my $params              = $forward_to{params};
    $controller_instance->$action( $self, $self->request, $params );
}

sub forward_with_filters {
    my $self       = shift;
    my %forward_to = Params::Validate::validate(
        @_,
        {   action => 1,
            controller => { type => SCALAR },

            params => { optional => 1, type => HASHREF },
        }
    );
    my $controller ||= $forward_to{controller};
    $controller    ||= caller;
    my $short_controller_name
        = Angelos::Utils::class2classsuffix($controller);
    my $controller_instance = $self->app->controller($short_controller_name);
    my $action              = $forward_to{action};
    my $params              = $forward_to{params};
    $controller_instance->_do_action( $self, $action, $params );
}

sub detach {
    my ( $self, %forward_to ) = @_;
    $self->forward(%forward_to);
    Angelos::Exception::Detach->throw( message => 'DETACH' );
}

sub detach_with_filter {
    my ( $self, %forward_to ) = @_;
    $self->forward_with_filters(%forward_to);
    Angelos::Exception::Detach->throw( message => 'DETACH' );
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

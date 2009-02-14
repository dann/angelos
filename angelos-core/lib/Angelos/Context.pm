package Angelos::Context;
use Angelos::Class;
use Angelos::Exceptions;
use Angelos::Utils;
use Params::Validate qw(SCALAR HASHREF);

with 'Angelos::Class::Pluggable';
with 'Angelos::Class::Loggable';

has 'app_class' => (
    is  => 'rw',
    isa => 'Str',
);

has 'app' => (
    is       => 'rw',
    handles  => [qw(controller model)],
);

has 'request' => (
    is      => 'rw',
    handles => [qw(params)],
);

has 'response' => ( is => 'rw', );

has 'stash' => (
    is      => 'rw',
    default => sub {
        +{};
    }
);

has 'finished' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has 'timing' => ( 
    is => 'rw',
    isa => 'Str',
);

has '_match' => ( is => 'rw', );

#has 'config' => ( is => 'rw', );

has 'home' => (
    is      => 'rw',
    handles => [qw(path_to)],
);

has 'project_structure' => (
    is => 'rw',
    isa => 'Angelos::ProjectStructure',
);

sub req {
    shift->request;
}

sub res {
    shift->response;
}

sub session {
    shift->request->session;
}

sub view {
    my ( $self, $view ) = @_;
    my $v = $self->engine->view($view);
    Angelos::Exception::ComponentNotFound->throw(
        level   => 'error',
        message => "view $view doesn't exist"
    ) unless $v;
    $v->context($self);
    $v;
}

sub action {
    my $self = shift;
    $self->_match->params->{action};
}

sub redirect {
    my ( $self, $location, $status ) = @_;
    unless ( $self->finished ) {
        $status ||= 302;
        $self->response->headers->header( 'Location' => $location );
        $self->response->status($status);
        $self->finished(1);
    }
}

# forward(action=> $action)
# forward(controller=> $controller, action => 'index', params=> aaa)
sub forward {
    my $self       = shift;
    my %forward_to = Params::Validate::validate(
        @_,
        {   action => 1,    # required
            controller => { type     => SCALAR },
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
        {   action => 1,    # required
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

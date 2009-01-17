package Angelos::Context;
use Angelos::Class;
use Angelos::Exceptions;
use Angelos::Utils;
use Params::Validate qw(SCALAR HASHREF);

with 'Angelos::Class::Pluggable';

has 'app' => (
    is       => 'rw',
    isa      => 'Angelos::Engine',
    required => 1,
    handles  => [qw(controller model)],
);

has 'request' => (
    is       => 'rw',
    required => 1
);

has 'response' => (
    is       => 'rw',
    required => 1
);

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

has '_match' => ( is => 'rw', );

# FIXME
# need to consider later
# this attribute should be added by plugin
# should I use Sub::Install or something like that?
has 'session' => (
    is  => 'rw',
    isa => 'HTTP::Session',
);

sub req {
    shift->request;
}

sub res {
    shift->response;
}

sub view {
    my ( $self, $view ) = @_;
    my $v = $self->app->view($view);
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

# redirect_to( action => $action) ?
# redirect_to( url => $url) ?
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
            controller => { type => SCALAR },
            #params     => { type => HASHREF },
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
            #params     => { type => HASHREF },
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
    Angelos::Exception::Detach->throw(message => 'DETACH');
}

sub detach_with_filter {
    my ( $self, %forward_to ) = @_;
    $self->forward_with_filters(%forward_to);
    Angelos::Exception::Detach->throw(message => 'DETACH');
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

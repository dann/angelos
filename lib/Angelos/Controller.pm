package Angelos::Controller;

use Mouse;
with( 'Angelos::Component', 'MouseX::Plaggerize', );

has '_plugin_app_ns' => (
    +default => sub {
        'Angelos::Controller';
    }
);

around 'new' => sub {
    my ( $next, $class, @args ) = @_;
    my $instance = $next->( $class, @args );
    $instance->run_hook('AFTER_INIT');
    $instance;
};

around 'do_action' => sub {
    my ( $next, $self, @args ) = @_;
    $self->run_hook('BEFORE_ACTION', @args);
    my $result = $self->$next(@args);
    $self->run_hook('AFTER_ACTION', @args);
    return $result;
};

sub do_action {
    my ($self, $context, $action, $params) = @_;
    $self->$action($context, $params);
}

no Mouse;

1;

package Angelos::Controller::Plugin::HookLogger;
use Angelos::Plugin;
use Angelos::Logger;

around 'new' => sub {
    my ( $next, $class, @args ) = @_;
    # oops
    # Mouse doesn't support around with new?
    Angelos::Logger->instance->log(
        level   => 'info',
        message => 'new',
    );
    return $next->( $class, @args );
};

before 'ACTION' => sub {
    my ( $self, $c, $action, $params ) = @_;
    Angelos::Logger->instance->log(
        level   => 'info',
        message => "BEFORE ACTION: $action, $params",
    );
};

after 'ACTION' => sub {
    my $self = shift;
    Angelos::Logger->instance->log(
        level   => 'info',
        message => "AFTER ACTION",
    );
};

1;

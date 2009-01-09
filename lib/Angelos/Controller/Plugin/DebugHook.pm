package Angelos::Controller::Plugin::DebugHook;
use Angelos::Plugin;
use Angelos::Logger;

after 'SETUP' => sub {
    my $self = shift;
    Angelos::Logger->instance->log(
        level   => 'info',
        message => "SETUP: class=" . ref $self,
    );
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
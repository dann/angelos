package Angelos::Controller::Plugin::DebugHook;
use Angelos::Plugin;

after 'SETUP' => sub {
    my $self = shift;
    warn $self->is_plugin_loaded('DebugHook');
    $self->log(
        level   => 'info',
        message => "SETUP: class=" . ref $self,
    );
};

before 'ACTION' => sub {
    my ( $self, $c, $action, $params ) = @_;
    $self->log(
        level   => 'info',
        message => "BEFORE ACTION: $action, $params",
    );
};

after 'ACTION' => sub {
    my $self = shift;
    $self->log(
        level   => 'info',
        message => "AFTER ACTION",
    );
};

1;

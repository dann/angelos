package Angelos::Debug;
use Mouse::Role;

sub log_message {
    my ( $self, $message ) = @_;
    Angelos::Logger->instance->log(
        level   => "info",
        message => "\n" . $message,
    );
}

1;

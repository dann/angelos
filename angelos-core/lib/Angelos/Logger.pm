package Angelos::Logger;
use Angelos::Class;
use Angelos::Exceptions;
use Angelos::Utils;
use UNIVERSAL::require;
use base 'Class::Singleton';

sub _new_instance {
    my $class     = shift;
    my $self      = bless {}, $class;
    my $app_class = shift;
    $self->{logger} = $self->create_logger;
    return $self;
}

sub create_logger {
    my $self = shift;
    require Angelos::Logger::Dispatch;
    Angelos::Logger::Dispatch->new(
        app_class        => $self->app_class,
        logger_conf_file => $self->logger_config_file
    );
}

sub app_class {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement app_class method' );
}

sub logger_config_file {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement logger_conf_file method' );
}

sub debug {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'debug' => $message );
}

sub warn {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'warn' => $message );
}

sub info {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'info' => $message );
}

sub critical {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'critical' => $message );
}

sub notice {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'notice' => $message );
}

sub error {
    my ( $self, $message ) = @_;
    $self->{logger}->log( 'error', $message );
}

__END_OF_CLASS__

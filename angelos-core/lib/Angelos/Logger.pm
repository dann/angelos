package Angelos::Logger;
use Angelos::Class;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Config;
use Angelos::Exceptions;

#$Log::Dispatch::Config::CallerDepth = 2;

has 'logger' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_logger',
);

sub build_logger {
    my $self = shift;
    my $config
        = Log::Dispatch::Configurator::YAML->new( $self->_logger_conf_path );
    Log::Dispatch::Config->configure($config);
    Log::Dispatch::Config->instance();
}

sub debug {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'debug',
    };
    $self->logger->log(%$log);
}

sub warn {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'warn',
    };
    $self->logger->log(%$log);
}

sub info {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'info',
    };
    $self->logger->log(%$log);
}

sub critical {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'critical',
    };
    $self->logger->log(%$log);
}

sub notice {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'notice',
    };
    $self->logger->log(%$log);
}

sub error {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'error',
    };
    $self->logger->log(%$log);
}

sub _logger_conf_path {
    Angelos::Config->logger_conf_path;
}

__END_OF_CLASS__

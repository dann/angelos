package Angelos::Logger;
use strict;
use warnings;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Config;
use Angelos::Exceptions;
use base 'Class::Singleton';

$Log::Dispatch::Config::CallerDepth = 2;

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    my $config
        = Log::Dispatch::Configurator::YAML->new( $self->_logger_conf_path );
    Log::Dispatch::Config->configure($config);
    $self->{logger} = Log::Dispatch::Config->instance();
    return $self;
}

sub debug {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'debug',
    };
    $self->{logger}->log(%$log);
}

sub warn {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'warn',
    };
    $self->{logger}->log(%$log);
}

sub info {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'info',
    };
    $self->{logger}->log(%$log);
}

sub critical {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'critical',
    };
    $self->{logger}->log(%$log);
}

sub notice {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'notice',
    };
    $self->{logger}->log(%$log);
}

sub error {
    my ( $self, $message ) = @_;
    my $log = {
        message => $message,
        level   => 'error',
    };
    $self->{logger}->log(%$log);
}

sub _logger_conf_path {
    Angelos::Config->logger_conf_path;
}

1;

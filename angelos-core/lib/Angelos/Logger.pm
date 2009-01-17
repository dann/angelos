package Angelos::Logger;
use strict;
use warnings;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Config;
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

sub log {
    my ( $self, %log ) = @_;
    $log{level} ||= 'debug';
    $self->{logger}->log(%log);
}

sub _logger_conf_path {
    Angelos::Config->logger_conf_path;
}

1;

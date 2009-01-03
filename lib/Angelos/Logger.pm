package Angelos::Logger;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Config;

our $LOGGER;

sub instance {
    my $class   = shift;
    return $LOGGER if $LOGGER;
    my $config = Log::Dispatch::Configurator::YAML->new($class->_logger_conf_path);
    Log::Dispatch::Config->configure($config);
    $LOGGER = Log::Dispatch::Config->instance();
    $LOGGER;
}

sub _logger_conf_path {
    my $class = shift;
    Angelos::Config->logger_conf_path;
}

1;

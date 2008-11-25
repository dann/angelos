package Angelos::Logger::Factory;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Utils;

sub create {
    my $class  = shift;
    # FIXME to customize with config
    my $config = Log::Dispatch::Configurator::YAML->new(
        Angelos::Utils->path_to( 'conf', 'log.yaml' ) );
    Log::Dispatch::Config->configure($config);
    Log::Dispatch::Config->instance();
}

1;

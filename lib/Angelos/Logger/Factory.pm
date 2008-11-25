package Angelos::Logger::Factory;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Utils;

sub create {
    my $class  = shift;
    my $config = Log::Dispatch::Configurator::YAML->new(
        Angelos::Utils->path_to( 'conf', 'log.yml' ) );
    Log::Dispatch::Config->configure($config);
    Log::Dispatch::Config->instance();
}

1;

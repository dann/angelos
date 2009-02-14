package Angelos::Logger::Dispatch;
use Angelos::Class;
use Angelos::Utils;
use UNIVERSAL::require;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;

with 'Angelos::Logger::Role';

has 'logger' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_logger',
);

$Log::Dispatch::Config::CallerDepth = 2;

sub build_logger {
    my $self = shift;

    my $logger = join '::', ( $self->_app_class, 'Logger', 'Backend' );
    $self->_generate_logger_class($logger);
    $logger->require;
    $logger->configure_and_watch(
        Log::Dispatch::Configurator::YAML->new( $self->_logger_conf_file ) );
    $logger->instance;
}

sub _generate_logger_class {
    my ($self, $logger) = @_;

    # Log::Dispatch::Config is Singleton class,
    # This causes trobule under mod_perl enviroment,
    # So, we generate application specific logger class
    eval <<"";
        package $logger;
        use base qw/Log\::Dispatch\::Config/;

}

sub log {
    my ( $self, $level, $message ) = @_;
    my $log = {
        level   => $level,
        message => $message,
    };
    $self->logger->log(%$log);
}

sub _logger_conf_file {
    Angelos::Utils::context()->project_structure->logger_conf_file;
}

sub _app_class {
    Angelos::Utils::context()->app_class;
}

__END_OF_CLASS__

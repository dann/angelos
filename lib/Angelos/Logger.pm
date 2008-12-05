package Angelos::Logger;
use Mouse;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Home;

has 'path' => (
    is      => 'rw',
    default => sub {
        my $self = shift;

        #FIXME debug
        Angelos::Home->path_to( 'log', "debug.log" );
    },
);

has 'conf_path' => (
    is      => 'rw',
    default => sub {
        Angelos::Home->path_to( 'conf', 'log.yaml' );
    },
);

has 'mode' => (
    is      => 'rw',
    default => sub {
        'debug';
    }
);

has 'logger' => (
    is      => 'rw',
    default => sub {
        shift->_create
    }
);

no Mouse;

sub log {
    my ( $self, $message, $level ) = @_;
    $level = $level || 'debug';
    eval { $self->logger->$level($message); };
}

sub _create {
    my $self   = shift;
    my $config = Log::Dispatch::Configurator::YAML->new( $self->conf_path );
    Log::Dispatch::Config->configure($config);
    Log::Dispatch::Config->instance();

}

__PACKAGE__->meta->make_immutable;

1;

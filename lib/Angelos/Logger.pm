package Angelos::Logger;
use Moose;
use Log::Dispatch::Config;
use Log::Dispatch::Configurator::YAML;
use Angelos::Home;

has 'path' => (
    is      => 'rw',
    default => sub {
        my $self = shift;
        Angelos::Home->path_to( 'log', $self->mode . ".log" );
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
        shift->create;
    }
);

no Moose;

sub log {
    my ( $self, $message, $level ) = @_;
    my $logger = Angelos::Logger::Factory->create;
    $level = $level || 'debug';
    eval { $logger->$level($message); };
}

sub create {
    my $self = shift;
    my $config = Log::Dispatch::Configurator::YAML->new( $self->conf_path );
    Log::Dispatch::Config->configure($config);
    Log::Dispatch::Config->instance();
}

__PACKAGE__->meta->make_immutable;

1;

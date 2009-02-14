package Angelos::Logger;
use Angelos::Class;
use Angelos::Exceptions;
use Angelos::Utils;
use UNIVERSAL::require;

has 'logger' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_logger',
);

sub build_logger {
    my $self = shift;
    require Angelos::Logger::Dispatch;
    Angelos::Logger::Dispatch->new;
}

sub debug {
    my ( $self, $message ) = @_;
    $self->logger->log('debug' => $message);
}

sub warn {
    my ( $self, $message ) = @_;
    warn $message;
    $self->logger->log('warn' => $message);
}

sub info {
    my ( $self, $message ) = @_;
    $self->logger->log('info'=> $message);
}

sub critical {
    my ( $self, $message ) = @_;
    $self->logger->log('critical' => $message );
}

sub notice {
    my ( $self, $message ) = @_;
    $self->logger->log('notice' => $message );
}

sub error {
    my ( $self, $message ) = @_;
    $self->logger->log('error', $message);
}


__END_OF_CLASS__

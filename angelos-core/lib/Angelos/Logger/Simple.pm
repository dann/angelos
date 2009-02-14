package Angelos::Logger::Simple;
use Angelos::Class;

sub log {
    my ($self, $level, $message) = @_;
    warn $message;
}

__END_OF_CLASS__

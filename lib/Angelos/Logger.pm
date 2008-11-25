package Angelos::Loggger;
use strict;
use warnings;
use Sub::Install qw( install_sub );
use Angelos::Logger::Factory;

my $caller = caller;

install_sub(
    {   as   => 'log',
        into => $caller,
        code => sub {
            my ( $self, $args ) = @_;
            my $logger = Angelos::Logger::Factory->create;
            my $level   = $args->{level} || 'debug';
            my $message = $args->{message};
            eval { $logger->$level($message); };
        }
    }
);

1;

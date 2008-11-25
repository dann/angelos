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
            my ( $self, $message, $level ) = @_;
            my $logger = Angelos::Logger::Factory->create;
            $level = $level || 'debug';
            eval { $logger->$level($message); };
            }
    }
);

1;

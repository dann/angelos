package Angelos::Logger;
use strict;
use warnings;
use Sub::Install qw( install_sub );
use Angelos::Logger::Factory;

my $caller = caller;

install_sub(
    {   as   => 'log',
        into => $caller,
        code => sub {
            # FIXME message and level aren't passed... wtf
            my ( $self, $message, $level ) = @_;
            my $logger = Angelos::Logger::Factory->create;
            $level = $level || 'debug';
            warn $message;
            eval { $logger->$level($message); };
            }
    }
);

1;

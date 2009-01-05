package Angelos::Controller::Plugin::Dumper;
use Angelos::Plugin;

use Angelos::Logger;
use Data::Dumper;

sub dump {
    my ($self, $args) = @_;
    my $result = Dumper $args;
    Angelos::Logger->instance->log(
        level => 'debug',
        message => $result,
    );
}

1;

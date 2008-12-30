package Angelos::Controller::Mixin::Dumper;
use Angelos::Mixin;

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

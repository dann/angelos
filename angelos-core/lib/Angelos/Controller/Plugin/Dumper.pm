package Angelos::Controller::Plugin::Dumper;
use Angelos::Plugin;
with 'Angelos::Class::Loggable';
use Data::Dumper;

sub dump {
    my ($self, $args) = @_;
    my $result = Dumper $args;
    $self->log(
        level => 'debug',
        message => $result,
    );
}

1;

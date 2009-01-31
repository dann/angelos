package Angelos::Request::Mixin::Dumper;
use Angelos::Class;
use Data::Dumper;
extends 'Angelos::Request::Mixin';

sub SETUP {
    my $self = shift;
    $self->install_method(
        'dump' => sub {
            my $self = shift;
            warn Data::Dumper::Dump $self;
        }
    );
}

__END_OF_CLASS__

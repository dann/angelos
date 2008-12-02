package Angelos::Dispatcher;
use Moose;
use MooseX::AttributeHelpers;
use Angelos::Dispatcher::Routes;

has 'dispatcher' => (
    is      => 'ro',
    handles => [ 'dispatch', 'run', 'add_route'],
    default => sub {
        Angelos::Dispatcher::Routes->new;
    }
);

no Moose;

__PACKAGE__->meta->make_immutable;

1;

package Angelos::Dispatcher;
use Moose;
use MooseX::AttributeHelpers;
use Path::Dispatcher;

has 'dispatcher' => (
    is      => 'ro',
    handles => [ 'dispatch', 'run' ],
    default => sub {
        Path::Dispatcher->new;
    }
);

has 'rules' => (
    metaclass => 'Collection::Array',
    is        => 'ro',
    isa       => 'ArrayRef',
    default   => sub { [] },
    provides  => { 'push' => 'add_rule', }
);

has 'default_rules' => (
    metaclass => 'Collection::Array',
    is        => 'ro',
    isa       => 'ArrayRef',
    default   => sub { [] },
    provides  => { 'push' => 'add_default_rule', }
);

no Moose;

__PACKAGE__->meta->make_immutable;

1;

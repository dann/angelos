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

sub BUILD {
    my $self = shift;
    $self->setup_rules;
}

sub setup_rules {
    my $self = shift;
    $self->dispatcher->add_rule($_) for @{ $self->default_rules };
    $self->dispatcher->add_rule($_) for @{ $self->rules };
}

__PACKAGE__->meta->make_immutable;

1;

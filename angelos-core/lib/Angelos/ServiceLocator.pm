package Angelos::ServiceLocator;
use strict;
use warnings;
use base 'Class::Singleton';

sub _new_instance {
    my $class     = shift;
    my $self      = bless {}, $class;
    my $app_class = shift;
    $self->{services} = +{};
    return $self;
}

sub get_service {
    my ( $self, $key ) = @_;
    $self->{services}->{$key};
}

sub load_service {
    my ( $self, $key, $obj ) = @_;
    $self->{services}->{$key} = $obj;
}

1;

package Angelos::Cache;
use strict;
use warnings;
use CHI;
use Angelos::Exceptions;
use base 'Class::Singleton';

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{cache} = $self->create_cache;
    return $self;
}

sub config {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement this method and return cache' );
}

sub create_cache {
    my $self = shift;
    CHI->new( %{ $self->config } );
}

sub get {
    shift->{cache}->get(@_);
}

sub set {
    my $self = shift;
    shift->{cache}->set(@_);
}

sub get_multi {
    shift->{cache}->get_multi(@_);
}

1;

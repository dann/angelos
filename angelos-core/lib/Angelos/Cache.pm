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
    CHI->new( %{ $self->config } || { driver => 'Memory' } );
}

sub get {
    shift->{cache}->get(@_);
}

sub set {
    my $self = shift;
    shift->{cache}->set(@_);
}

sub get_multi_arrayref {
    shift->{cache}->get_multi_arrayref(@_);
}


sub get_multi_hashref {
    shift->{cache}->get_multi_hashref(@_);
}

sub set_multi {
    shift->{cache}->set_multi(@_);
}

sub remove {
    shift->{cache}->remove(@_);
}

sub remove_multi {
    shift->{cache}->remove_multi(@_);
}

sub expire {
    shift->{cache}->expire(@_);
}

sub expire_if {
    shift->{cache}->expire_if(@_);
}

sub clear {
    shift->{cache}->clear(@_);
}

sub get_keys {
    shift->{cache}->get_keys(@_);
}

sub is_valid {
    shift->{cache}->is_valid(@_);
}

sub exists_and_is_expired {
    shift->{cache}->exists_and_is_expired(@_);
}

sub get_expires_at {
    shift->{cache}->get_expires_at(@_);
}

sub get_object {
    shift->{cache}->get_object(@_);
}

1;

__END__

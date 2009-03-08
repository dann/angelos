package Angelos::I18N;
use strict;
use warnings;
use UNIVERSAL::require;
use Carp ();
use Angelos::Exceptions;
use base 'Class::Singleton';

=head1 NAME
 
Angelos::I18N - Provides internationalization function 

=head1 SYNOPSIS
 
 
=head1 Methods
 
=head2 loc("string [_1]", $arg)
 
=cut

=head2 loc_lang
 
Set the locale.
 
=head1 Localization Files
 
=cut

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{localizer} = $self->setup_localizer;
    return $self;
}

sub setup_localizer {
    my $self            = shift;
    my $localizer_class = 'Angelos::I18N::Localizer::' . $self->localizer;
    $localizer_class->require
        or Carp::croak "$localizer_class must be installed";
    $localizer_class->new( po_dir => $self->po_dir );
}

sub localizer {
    'DataLocalize';
}

sub po_dir {
    Angelos::Exception::AbstractMethod->throw(
        message => 'Sub class must implement po_dir method' );
}

sub loc {
    my ( $self, $key, @args ) = @_;
    $self->{localizer}->loc( $key, @args );
}

sub loc_lang {
    my ( $self, @langs ) = @_;
    $self->{localizer}->loc_lang(@langs);
}

1;

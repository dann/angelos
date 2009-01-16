package Angelos::I18N;
use strict;
use warnings;
use Angelos::Home;
use base 'Class::Singleton';

=head1 NAME
 
Angelos::I18N - Provides internationalization function 

=head1 SYNOPSIS
 
  Angelos::I18N->instance->loc_lang('ja'),
  Angelos::I18N->instance->loc('Hello'),
 
=head1 Methods
 
=head2 loc("string [_1]", $arg)
 
See Locale::Maketext::Simple.
 
=cut

=head2 loc_lang
 
Set the locale.
See Locale::Maketext::Simple.
 
=head1 Localization Files
 
The .po files are kept in conf/locales.
 
=cut

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;

    require Locale::Maketext::Simple;
    my $config = {
        Path     => Angelos::Home->path_to( 'share', 'po' ),
        Style    => 'maketext',
        Export   => 'loc',
        Subclass => 'I18N',
    };
    my ( $loc, $loc_lang ) = Locale::Maketext::Simple->load_loc(%$config);
    $loc ||= Locale::Maketext::Simple->default_loc(%$config);
    $self->{loc}      = $loc;
    $self->{loc_lang} = $loc_lang;

    return $self;
}

sub loc {
    my ( $self, $message, $arg ) = @_;
    my $loc = $self->{loc};
    $loc->( $message, $arg );
}

sub loc_lang {
    my ( $self, $lang ) = @_;
    my $loc_lang = $self->{loc_lang};
    $loc_lang->($lang);
}

1;

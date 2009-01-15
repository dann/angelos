package Angelos::I18N;
use strict;
use warnings;
use base 'Exporter';
use Angelos::Config;
use Angelos::Home;

=head1 NAME
 
Angelos::I18N - Provides internationalization function 

=head1 SYNOPSIS
 
  Angelos::I18N->loc_lang('ja'),
  Angelos::I18N->loc('Hello'),
 
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

our $LOC;
our $LOC_LANG;

sub loc {
    my ($class, $message, $arg) = @_;
    $class->initialize unless $LOC;
    $LOC->($message, $arg);
}

sub loc_lang {
    my ($class, $lang) = @_;
    $class->initialize unless $LOC_LANG;
    $LOC_LANG->($lang);
}

sub initialize {
    my %args = ();
    require Locale::Maketext::Simple;
    $args{Path}     ||=  Angelos::Home->path_to( 'share', 'po' );
    $args{Style}    ||= 'maketext';
    $args{Export}   ||= 'loc';
    $args{Subclass} ||= 'I18N';
    ($LOC, $LOC_LANG) = Locale::Maketext::Simple->load_loc(%args);
    $LOC ||=  Locale::Maketext::Simple->default_loc(%args);
}

1;

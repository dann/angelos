package Angelos::I18N;
use strict;
use warnings;
use base 'Exporter';
use Angelos::Config;
use Angelos::Home;

our @EXPORT_OK = qw(loc loc_lang);

=head1 NAME
 
Angelos::I18N - Provides internationalization function 

=head1 SYNOPSIS
 
  use Angelos::I18N qw(loc loc_lang);
 
  loc_lang('ja'); # set the locale
  loc('Hello'),
 
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

sub import {
    my ( $class, %args ) = @_;
    $class->setup;
}

sub setup {
    # FIXME How should I set home dir before this module is imported
    my $po_dir = Angelos::Home->path_to( 'share', 'po' );
    require Locale::Maketext::Simple;
    Locale::Maketext::Simple->import(
        Path   => $po_dir,
        Decode => 1,
        Style  => 'gettext',
        Export => "loc",
    );
}

1;

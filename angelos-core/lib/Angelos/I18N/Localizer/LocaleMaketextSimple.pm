package Angelos::I18N::Localizer::LocaleMaketextSimple;
use Angelos::Class;
use Angelos::Exceptions;
with 'Angelos::I18N::Localizer::Role';

has '_loc' => ( is => 'rw', );

has '_loc_lang' => ( is => 'rw', );

=head1 NAME
 

=head1 SYNOPSIS
 
 
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

sub BUILD {
    my $self = shift;
    require Locale::Maketext::Simple;
    my $config = {
        Path     => $self->po_dir,
        Style    => 'maketext',
        Export   => 'loc',
        Subclass => 'I18N',
    };
    my ( $loc, $loc_lang ) = Locale::Maketext::Simple->load_loc(%$config);
    $loc ||= Locale::Maketext::Simple->default_loc(%$config);
    $self->_loc($loc);
    $self->_loc_lang($loc_lang);
    $self;
}

sub loc {
    my ( $self, $message, @arg ) = @_;
    $self->_loc->( $message, @arg );
}

sub loc_lang {
    my ( $self, $lang ) = @_;
    $self->_loc_lang->($lang);
}

__END_OF_CLASS__

__END__

package Angelos::I18N::Localizer::DataLocalize;
use Angelos::Class;
use UNIVERSAL::require;

with 'Angelos::I18N::Localizer::Role';

has 'localizer' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_localizer',
);

sub build_localizer {
    my $self      = shift;
    Data::Localize->require or Carp::croak "Data Localize isn't installed";
    my $localizer = Data::Localize->new;
    $localizer->add_localizer(
        class => "Gettext",
        path  => $self->po_dir . "/*.po"
    );
    $localizer;
}

sub loc {
    my $self = shift;
    $self->localizer->localize(@_);
}

sub loc_lang {
    my $self = shift;
    $self->localizer->set_languages(@_);
}

__END_OF_CLASS__

__END__

package Angelos::Class::Localizable;
use Mouse::Role;
use Angelos::I18N;

sub loc {
    my ( $self, $message, $arg ) = @_;
    Angelos::I18N->loc($message, $arg);
}

sub loc_lang {
    my ( $self, $lang ) = @_;
    Angelos::I18N->loc_lang($lang);
}

1;

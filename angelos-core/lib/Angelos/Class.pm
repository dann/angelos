package Angelos::Class;
use Mouse;
use utf8;

sub init_class {
    my $klass = shift;

    my $meta = Mouse::Meta::Class->initialize($klass);
    $meta->superclasses('Mouse::Object') unless $meta->superclasses;

    no strict 'refs';
    no warnings 'redefine';
    *{ $klass . '::meta' } = sub {$meta};
}

sub import {
    my $class = shift;

    my $caller = caller(0);
    return if $caller eq 'main';

    no strict 'refs';
    *{"$caller\::__END_OF_CLASS__"} = sub {
        my $caller = caller(0);
        __END_OF_CLASS__($caller);
    };

    strict->import;
    warnings->import;
    utf8->import;

    init_class($caller);
    Mouse->export_to_level(1);

}

sub __END_OF_CLASS__ {
    my ( $caller, ) = @_;
    Mouse::unimport;
    $caller->meta->make_immutable( inline_destructor => 1 );
    "END_OF_CLASS";
}

1;

package Angelos::Utils;
use strict;
use warnings;
use Carp ();
use Path::Class;
use Class::Inspector;

# steal from Catalyst
sub class2appclass {
    my $class = shift || '';
    my $appname = '';
    if ( $class =~ /^(.+?)::([MVC]|Model|View|Controller)::.+$/ ) {
        $appname = $1;
    }
    return $appname;
}

sub class2classprefix {
    my $class = shift || '';
    my $prefix;
    if ( $class =~ /^(.+?::([MVC]|Model|View|Controller))::.+$/ ) {
        $prefix = $1;
    }
    return $prefix;
}

sub class2classsuffix {
    my $class = shift || '';
    my $prefix = class2appclass($class) || '';
    $class =~ s/$prefix\:://;
    return $class;
}

sub ensure_class_loaded {
    my $class = shift;
    my $opts  = shift;

    Carp::croak "Malformed class Name $class"
        if $class =~ m/(?:\b\:\b|\:{3,})/;

    Carp::croak "Malformed class Name $class"
        if $class =~ m/[^\w:]/;

    Carp::croak
        "ensure_class_loaded should be given a classname, not a filename ($class)"
        if $class =~ m/\.pm$/;

    return
        if !$opts->{ignore_loaded}
            && Class::Inspector->loaded($class)
    ;    # if a symbol entry exists we don't load again

 # this hack is so we don't overwrite $@ if the load did not generate an error
    my $error;
    {
        local $@;
        my $file = $class . '.pm';
        $file =~ s{::}{/}g;
        eval { CORE::require($file) };
        $error = $@;
    }

    die $error if $error;
    die "require $class was successful but the package is not defined"
        unless Class::Inspector->loaded($class);

    return 1;
}

sub env_value {
    my ( $class, $key ) = @_;

    $key = uc($key);
    my @prefixes = ( class2env($class), 'CATALYST' );

    for my $prefix (@prefixes) {
        if ( defined( my $value = $ENV{"${prefix}_${key}"} ) ) {
            return $value;
        }
    }

    return;
}

sub class2env {
    my $class = shift || '';
    $class =~ s/::/_/g;
    return uc($class);
}

1;

package Angelos::Utils;
use strict;
use warnings;
use Carp ();
use File::Spec;
use YAML ();
use Encode;
use Angelos::Registrar;

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

sub env_value {
    my ( $class, $key ) = @_;

    $key = uc($key);
    my @prefixes = ( class2env($class), 'ANGELOS' );

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

sub load_yaml {
    my $filename = shift;
    my $IN;
    if ( ref $filename eq 'GLOB' ) {
        $IN = $filename;
    }
    else {
        open $IN, '<:utf8', $filename
            or die "can't open $filename";
    }
    YAML::Load( Encode::decode( 'utf8', YAML::Dump( YAML::LoadFile($IN) ) ) );
}

sub context {
    Angelos::Registrar::context();
}

sub path_to {
    my $class = shift || '';
    $class->context()->path_to(@_);
}

1;


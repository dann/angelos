package Angelos::Utils;
use strict;
use warnings;
use Carp ();
use File::Spec;

use vars qw/$SHARE_ROOT $ANGELOS_ROOT/;

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

sub is_plugins_loaded {
    my $class = shift || '';
    my $plugin_type = shift;
    my $plugin_name = shift;
    my $plugin = Angelos::Config->instance->plugins($plugin_type, $plugin_name);
    $plugin ? 1 : 0;
}

1;


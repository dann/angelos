package Angelos::Config::Loader;
use YAML ();
use Storable;
use Encode;
use Angelos::Config::Loader;

our $HasKwalify;
eval {
    require Kwalify;
    $HasKwalify++;
};

# TODO: cache config
sub load {
    my ( $class, $stuff, $schema ) = @_;

    my $config =$class->_make_config($stuff);
    $class->_validate_config_if_nessesary( $config, $schema );

    return $config;
}

sub _make_config {
    my ($class, $stuff) = @_;
    if ( ref $stuff && ref $stuff eq 'HASH' ) {
        $config = Storable::dclone($stuff);
    }
    else {
        open my $fh, '<:utf8', $stuff or die $!;
        $config = YAML::LoadFile($fh);
        close $fh;
    }
    $config;
}

sub _validate_config_if_nessesary {
    my ( $class, $config, $schema ) = @_;
    if ( $HasKwalify && $schema ) {
        my $res = Kwalify::validate( $schema, $config );
        unless ( $res == 1 ) {
            die "config.yaml validation error : $res";
        }
    }
    else {
        warn "Kwalify is not installed. Skipping the config validation."
            if $^W;
    }

}
1;

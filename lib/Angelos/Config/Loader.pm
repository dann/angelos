package Angelos::Config::Loader;
use YAML ();
use Storable;
use Encode;
use Angelos::Config::Validator;
use Angelos::Exceptions;

sub load {
    my ( $class, $stuff, $schema ) = @_;

    my $config = $class->_make_config($stuff);
    Angelos::Config::Validator->validate_config( $config, $schema );

    return $config;
}

sub _make_config {
    my ( $class, $stuff ) = @_;
    if ( ref $stuff && ref $stuff eq 'HASH' ) {
        $config = Storable::dclone($stuff);
    }
    else {
        open my $fh, '<:utf8', $stuff or Angelos::Exception::FileNotFoundError->throw($!);
        $config = YAML::LoadFile($fh);
        close $fh;
    }
    $config;
}

1;

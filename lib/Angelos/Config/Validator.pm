package Angelos::Config::Validator;

our $HasKwalify;
eval {
    require Kwalify;
    $HasKwalify++;
};

sub validate_config {
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

package Angelos::Exception;
use Carp ();

sub throw {
    my $class = shift;
    my %params = @_ == 1 ? ( error => $_[0] ) : @_;

    my $message = $params{message} || $params{error} || $! || '';

    local $Carp::CarpLevel = 1;

    Carp::croak($message);
}

1;

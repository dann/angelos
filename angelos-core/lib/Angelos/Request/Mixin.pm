package Angelos::Request::Mixin;
use Angelos::Class;
use Data::Util qw(:all);

sub install_method {
    my ( $self, $method_name, $code ) = @_;
    install_subroutine( 'HTTP::Engine::Request', $method_name => $code, );
}


__END_OF_CLASS__

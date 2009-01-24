package Angelos::Response::Mixin;
use Angelos::Class;
use Data::Util qw(:all);

sub install_method {
    my ( $self, $method_name, $code ) = @_;
    install_subroutine( 'HTTP::Engine::Response', $method_name => $code, );
}


__END_OF_CLASS__

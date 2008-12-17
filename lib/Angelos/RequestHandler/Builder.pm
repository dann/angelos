package Angelos::RequestHandler::Builder;
use UNIVERSAL::require;
use Angelos::Config;
use Data::Dumper;

sub build {
    my $class                       = shift;
    my $application_request_handler = shift;
    my $middlewares                 = $class->_load_middlewares;
    $class->_build_request_handler( $application_request_handler,
        $middlewares );
}

sub _build_request_handler {
    my ( $class, $application_request_handler, $middlewares ) = @_;
    my $request_handler = $application_request_handler;
    for my $middleware ( @{$middlewares} ) {
        warn $middleware;
        $middleware->require or die $@;
        $request_handler = $middleware->wrap($request_handler);
    }
    $request_handler;
}

sub _load_middlewares {
    Angelos::Config->load->{middlewares} || [];
}

1;

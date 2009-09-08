package Angelos::Middleware::Builder;
use Mouse;
use UNIVERSAL::require;
use Angelos::Config;
use Angelos::Exceptions;

with 'Angelos::Class::Configurable';

sub build {
    my $class                       = shift;
    my $application_request_handler = shift;
    my $middlewares                 = $class->_get_middlewares;
    my $handler
        = $class->_build_request_handler( $application_request_handler,
        $middlewares );
    return $handler;
}

sub _build_request_handler {
    my ( $class, $application_request_handler, $middlewares ) = @_;

    for my $middleware ( @{$middlewares} ) {
        my $middleware_name
            = $class->resovle_middleware_name( $middleware->{module} );
        my $config = $middleware->{config} || {};
        Mouse::load_class($middleware_name);
        $middleware_name->new($config);
    }

}

sub resovle_middleware_name {
    my ( $class, $name ) = @_;
    my $middleeware_name;
    if ( index( $name, '+' ) == 0 ) {
        $middleeware_name = $name;
    }
    else {
        $middleeware_name = 'Angelos::Middleware::' . $name;
    }
    return $middleeware_name;
}

sub _get_middlewares {
    my $self = shift;
    $self->config->middlewares;
}

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

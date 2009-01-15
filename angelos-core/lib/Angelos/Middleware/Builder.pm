package Angelos::Middleware::Builder;
use UNIVERSAL::require;
use Angelos::Config;
use Data::Dumper;

sub build {
    my $class                       = shift;
    my $application_request_handler = shift;
    my $middlewares                 = $class->_get_middlewares;
    $class->_build_request_handler( $application_request_handler,
        $middlewares );
}

sub _build_request_handler {
    my ( $class, $application_request_handler, $middlewares ) = @_;
    my $request_handler = $application_request_handler;
    for my $middleware ( @{$middlewares} ) {
        my $module = $middleware->{module};
        $module->require or die $@;
        my $middleware_instance
            = $module->new( %{ $middleware->{config} } || {} );
        $request_handler = $middleware_instance->wrap($request_handler);
    }
    $request_handler;
}

sub _get_middlewares {
    Angelos::Config->instance->middlewares;
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

package Angelos::Middleware::MethodOverride;
use HTTP::Engine::Middleware;

has 'HTTP_METHODS' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub {
        return [ 'GET', 'HEAD', 'PUT', 'POST', 'DELETE' ];
    }
);

has 'METHOD_OVERRIDE_PARAM_KEY' => (
    is      => 'rw',
    isa     => 'Str',
    default => '_method',
);

has 'HTTP_METHOD_OVERRIDE_HEADER' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'X-HTTP-Method-Override',
);

before_handle {
    my ( $c, $self, $req ) = @_;
    $self->override_request_method($req);
    $req;
};

sub override_request_method {
    my ( $self, $req ) = @_;

    my $method = $req->method;
    if ( $method && uc $method ne 'POST' ) {
        return $req;
    }

    my $overload = $req->param( $self->METHOD_OVERRIDE_PARAM_KEY )
        || $req->header( $self->HTTP_METHOD_OVERRIDE_HEADER );

    if ( ($overload && grep { $_ eq $overload } @{ $self->HTTP_METHODS } ) != 0 ) {
        $req->method( uc $overload ) if $overload;
    }
    $req;
}

__MIDDLEWARE__

__END__

=head1 NAME

Angelos::Middleware::MethodOverride - documentation is TODO

=head1 SYNOPSIS

=cut


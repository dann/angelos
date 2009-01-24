package Angelos::Middleware::OverloadPost;
use Angelos::Class;
extends 'Angelos::Middleware';

sub wrap {
    my ( $self, $next ) = @_;

    sub {
        my $req = shift;
        $self->overload_request_method($req);
        my $res = $next->($req);
        $res;
    }
}

sub overload_request_method {
    my ( $self, $req ) = @_;

    my $method = $req->method;
    return $req unless $method && uc $method eq 'POST';

    my $overload = $req->param('_method')
        || $req->param('x-tunneled-method')
        || $req->header('X-HTTP-Method-Override');
    $req->method($overload) if $overload;
    $req;
}

__END_OF_CLASS__


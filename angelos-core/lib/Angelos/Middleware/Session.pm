package Angelos::Middleware::Session;
use Angelos::Class;

BEGIN {
    *HTTP::Engine::Request::session = sub {
        my ( $self, $session ) = @_;
        $self->{session} = $session if $session;
        $self->{session};
    };
}

sub wrap {
    my ( $self, $next ) = @_;
    sub {
        my $req = shift;

        # FIXME fix later
        my $session
            = Angelos::Engine::Plugin::Session::Builder->new->build($req);
        $req->session($session);
        my $res = $next->($req);
        $req->session->response_filter($res);
        $req->session->finalize;
        $res;
    }
}

__END_OF_CLASS__

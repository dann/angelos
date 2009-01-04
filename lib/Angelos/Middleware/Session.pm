package Angelos::Middleware::Session;
use Mouse;
use Angelos::SessionBuilder;

# TODO
# session state, store, id should be configurable
# in this class.

has 'session_builder' => (
    is => 'rw',
    default => sub {
        Angelos::SessionBuilder->new->build;
    }
);

sub BUILD {
    # add attribute to request at build time?
}

sub wrap {
    my ( $self, $next ) = @_;

    sub {
        my $req = shift;
        my $session = $self->session_builder->build( $req );

        # FIXME Fix later
        # How should I add attribute to HTTP::Engine::Request?
        # Mouse class can't be mutable 
        # almost all engine plugin should be middleware 
        no strict 'refs';
        no warnings 'redefine';
        *{'HTTP::Engine::Request::session'} = sub {
            return $session;
        };
        
        my $res = $next->($req);

        $session->response_filter( $res );
        $session->finalize;
        $res;
    }
}

1;

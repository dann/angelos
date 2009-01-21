package Angelos::Middleware::Session;
use Angelos::Class;
use HTTP::Session;
use Angelos::Config;
use UNIVERSAL::require;

BEGIN {
    *HTTP::Engine::Request::session = sub {
        my ( $self, $session ) = @_;
        $self->{session} = $session if $session;
        $self->{session};
    };

}

has 'store' => (
    is      => 'rw',
    default => sub {
        +{  class  => 'HTTP::Session::Store::OnMemory',
            config => +{},
        };
    }
);

has 'state' => (
    is      => 'rw',
    is      => 'rw',
    default => sub {
        +{  class  => 'HTTP::Session::State::Cookie',
            config => +{},
        };
    }
);

has 'id' => (
    is      => 'rw',
    default => 'HTTP::Session::ID::MD5'
);

sub wrap {
    my ( $self, $next ) = @_;
    sub {
        my $req     = shift;
        my $session = $self->build_session($req);
        $req->session($session);
        my $res = $next->($req);
        $req->session->response_filter($res);
        $req->session->finalize;
        $res;
        }
}

sub build_session {
    my ( $self, $request ) = @_;
    HTTP::Session->new(
        store   => $self->_build_session_store,
        state   => $self->_build_session_state($request),
        id      => $self->id,
        request => $request,
    );
}

sub _build_session_store {
    my $self                = shift;
    my $session_store_class = $self->store->{class};
    $session_store_class->require;
    $session_store_class->new( $self->store->{config} );
}

sub _build_session_state {
    my $self                = shift;
    my $session_state_class = $self->state->{class};
    $session_state_class->require;
    $session_state_class->new( $self->state->{config} );
}

__END_OF_CLASS__

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 CONTRIBUTORS

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

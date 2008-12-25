package Angelos::Session::Builder;
use Mouse;
use HTTP::Session;
use Angelos::Config;
use UNIVERSAL::require;

no Mouse;

sub construct_session {
    my ( $self, $request ) = @_;
    HTTP::Session->new(
        store   => $self->_build_session_store,
        state   => $self->_build_session_state($request),
        id      => $self->_session_id_builder_class,
        request => $request,
    );
}

sub _build_session_store {
    my $self                = shift;
    my $session_store_class = $self->_session_store_class;
    $session_store_class->require;
    $session_store_class->new( $self->_session_store_params );
}

sub _session_store_class {
    return 'HTTP::Session::Store::OnMemory'
        unless Angelos::Config->session->{store}->{type};
    return Angelos::Config->session->{store}->{type};
}

sub _session_store_params {
    Angelos::Config->session->{store}->{config} || {};
}

sub _build_session_state {
    my $self                = shift;
    my $session_state_class = $self->_session_state_class;
    $session_state_class->require;
    $session_state_class->new( $self->_session_state_params );
}

sub _session_state_class {
    return 'HTTP::Session::State::Cookie'
        unless Angelos::Config->session->{state}->{type};
    return Angelos::Config->session->{state}->{class};
}

sub _session_state_params {
    Angelos::Config->session->{state}->{config} || {};
}

__PACKAGE__->meta->make_immutable;

1;

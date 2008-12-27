package Angelos::SessionBuilder;
use Mouse;
use HTTP::Session;
use Angelos::Config;
use UNIVERSAL::require;

no Mouse;

sub build {
    my ( $self, $request ) = @_;
    HTTP::Session->new(
        store   => $self->_build_session_store,
        state   => $self->_build_session_state($request),
        id      => $self->_session_id_class,
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
        unless _session()->{store}->{type};
    return _session()->{store}->{type};
}

sub _session_store_params {
    _session()->{store}->{config} || {};
}

sub _build_session_state {
    my $self                = shift;
    my $session_state_class = $self->_session_state_class;
    $session_state_class->require;
    $session_state_class->new( $self->_session_state_params );
}

sub _session_state_class {
    return 'HTTP::Session::State::Cookie'
        unless _session()->{state}->{type};
    return _session()->{state}->{class};
}

sub _session_state_params {
    _session()->{state}->{config} || {};
}

sub _session_id_class {
    _session()->{id} || 'HTTP::Session::ID::MD5';
}

sub _session {
    Angelos::Config->global('session') or die 'session config must be set';
}

__PACKAGE__->meta->make_immutable;

1;

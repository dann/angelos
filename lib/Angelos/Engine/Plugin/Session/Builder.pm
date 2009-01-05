package Angelos::Engine::Plugin::Session::Builder;
use Mouse;
use HTTP::Session;
use Angelos::Config;
use UNIVERSAL::require;

has 'session_store_class' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        $self->_session()->{store}->{class}
            || 'HTTP::Session::Store::OnMemory';
    }
);

has 'session_store_params' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {
        my $self = shift;
        $self->_session()->{store}->{config} || {};
    }
);

has 'session_state_class' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        $self->_session()->{state}->{class} || 'HTTP::Session::State::Cookie';
    }
);

has 'session_state_params' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {
        my $self = shift;
        $self->_session()->{state}->{config} || {};
    }
);

has 'session_id_class' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        $self->_session()->{id} || 'HTTP::Session::ID::MD5';
    }
);

no Mouse;

sub build {
    my ( $self, $request ) = @_;
    HTTP::Session->new(
        store   => $self->_build_session_store,
        state   => $self->_build_session_state($request),
        id      => $self->session_id_class,
        request => $request,
    );
}

sub _build_session_store {
    my $self                = shift;
    my $session_store_class = $self->session_store_class;
    $session_store_class->require;
    $session_store_class->new( $self->session_store_params );
}

sub _build_session_state {
    my $self                = shift;
    my $session_state_class = $self->session_state_class;
    $session_state_class->require;
    $session_state_class->new( $self->session_state_params );
}

sub _session {
    my $session_plugin = Angelos::Config->plugins( 'engine', 'Session' )
        or die
        'session config must be set before the session plugin used at global section in conf/config.yaml';
    $session_plugin;
}

__PACKAGE__->meta->make_immutable;

1;

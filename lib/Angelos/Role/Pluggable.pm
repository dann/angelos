package Angelos::Role::Pluggable;
use Carp;
use Mouse::Role;
use Module::Pluggable::Object;
use Mouse::Util;

our $VERSION = '0.0008';

=head1 NAME

    MooseX::Object::Pluggable - Make your classes pluggable

=head1 SYNOPSIS

    package MyApp;
    use Mouse;

    with 'Angelos::Role::Pluggable';

    ...

    package MyApp::Plugin::Pretty;
    use Mouse::Role;

    sub pretty{ print "I am pretty" }

    1;

    #
    use MyApp;
    my $app = MyApp->new;
    $app->load_plugin('Pretty');
    $app->pretty;
=cut

has _plugin_ns => (
    is       => 'rw',
    required => 1,
    isa      => 'Str',
    default  => sub {'Plugin'},
);

has _plugin_app_ns => (
    is       => 'rw',
    required => 1,
    isa      => 'Str',
    default  => sub { ref shift },
);

has _plugin_loaded => (
    is       => 'rw',
    required => 1,
    isa      => 'HashRef',
    default  => sub { {} }
);

has _plugin_locator => (
    is        => 'rw',
    required  => 1,
    lazy      => 1,
    isa       => 'Module::Pluggable::Object',
    clearer   => '_clear_plugin_locator',
    predicate => '_has_plugin_locator',
    builder   => '_build_plugin_locator'
);

sub load_plugins {
    my ( $self, @plugins ) = @_;
    die("You must provide a plugin name") unless @plugins;

    my $loaded = $self->_plugin_loaded;
    my @load   = grep { not exists $loaded->{$_} } @plugins;
    my @roles  = map { $self->_role_from_plugin($_) } @load;

    if ( $self->_load_and_apply_role(@roles) ) {
        @{$loaded}{@load} = @roles;
        return 1;
    }
    else {
        return;
    }
}

sub load_plugin {
    my $self = shift;
    $self->load_plugins(@_);
}

sub _role_from_plugin {
    my ( $self, $plugin ) = @_;

    return $1 if ( $plugin =~ /^\+(.*)/ );

    my $o = join '::', $self->_plugin_ns, $plugin;

    #Father, please forgive me for I have sinned.
    my @roles = grep {/${o}$/} $self->_plugin_locator->plugins;

    croak("Unable to locate plugin '$plugin'") unless @roles;
    return $roles[0] if @roles == 1;
    return shift @roles;
}

=head2 _load_and_apply_role @roles

Require C<$role> if it is not already loaded and apply it. This is
the meat of this module.

=cut

sub _load_and_apply_role {
    my ( $self, @roles ) = @_;
    die("You must provide a role name") unless @roles;

    foreach my $role (@roles) {
        eval { Mouse::load_class($role) };
        confess("Failed to load role: ${role} $@") if $@;
    }
    Mouse::Util::apply_all_roles( (ref $self, @roles) );
    return 1;
}

sub _build_plugin_locator {
    my $self = shift;
    my $locator = Module::Pluggable::Object->new(
        search_path => [
            map { join '::', ( $_, $self->_plugin_ns ) } $self->_plugin_app_ns
        ]
    );
    return $locator;
}

1;

__END__;

1;

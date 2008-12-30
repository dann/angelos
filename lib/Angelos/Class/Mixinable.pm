package Angelos::Class::Mixinable;
use Carp ();
use Mouse::Role;
use Module::Pluggable::Object;
use Mouse::Util;

has _mixin_ns => (
    is       => 'rw',
    required => 1,
    isa      => 'Str',
    default  => sub {'Mixin'},
);

has _mixin_app_ns => (
    is       => 'rw',
    required => 1,
    isa      => 'ArrayRef',
    default  => sub { [ ref shift, 'Angelos' ] },
);

has _mixin_loaded => (
    is       => 'rw',
    required => 1,
    isa      => 'HashRef',
    default  => sub { {} }
);

has _mixin_locator => (
    is        => 'rw',
    required  => 1,
    lazy      => 1,
    isa       => 'Module::Pluggable::Object',
    clearer   => '_clear_mixin_locator',
    predicate => '_has_mixin_locator',
    builder   => '_build_mixin_locator'
);

sub load_mixins {
    my ( $self, @mixins ) = @_;
    die("You must provide a mixin name") unless @mixins;

    my $loaded = $self->_mixin_loaded;
    my @load   = grep { not exists $loaded->{$_} } @mixins;
    my @roles  = map { $self->_role_from_mixin($_) } @load;

    if ( $self->_load_and_apply_role(@roles) ) {
        @{$loaded}{@load} = @roles;
        return 1;
    }
    else {
        return;
    }
}

sub load_mixin {
    my $self = shift;
    $self->load_mixins(@_);
}

sub _role_from_mixin {
    my ( $self, $mixin ) = @_;

    return $1 if ( $mixin =~ /^\+(.*)/ );

    my $o = join '::', $self->_mixin_ns, $mixin;

    #Father, please forgive me for I have sinned.
    my @roles = grep {/${o}$/} $self->_mixin_locator->mixins;

    Carp::croak("Unable to locate mixin '$mixin'") unless @roles;
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
    Mouse::Util::apply_all_roles( ( ref $self, @roles ) );
    return 1;
}

sub _build_mixin_locator {
    my $self    = shift;
    my $locator = Module::Pluggable::Object->new(
        search_path => [
            map { join '::', ( $_, $self->_mixin_ns ) }
                @{ $self->_mixin_app_ns }
        ]
    );
    return $locator;
}

1;

__END__

=head1 NAME

   Angelos::Class::Mixinable - Make your classes pluggable

=head1 SYNOPSIS

    package MyApp;
    use Mouse;

    with 'Angelos::Class::Mixinable';

    ...

    package MyApp::Mixin::Pretty;
    use Mouse::Role;

    sub pretty{ print "I am pretty" }

    1;

    #
    use MyApp;
    my $app = MyApp->new;
    $app->load_mixin('Pretty');
    #You may want to use load_mixins to load multiple Role Classes if you have
    #$app->load_mixins(qw/Pretty MorePretty/);
    $app->pretty;


=head1 DESCRIPTION

This module works like L<Mouse::Role>, differences is you can set Role classes dynamically.

=head1 METHOD

=head1 load_mixin

set a Role Class

=head2 load_mixins

set Role Classes

=head1 SEE ALSO

L<Mouse::Role> L<Module::Pluggable::Object> L<Mouse::Util>

=cut

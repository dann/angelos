package Angelos::Component::Loader;
use Mouse;
use Module::Pluggable::Object;
use Angelos::Utils;
use Devel::InnerPackage;
use Angelos::Exception;
use Scalar::Util;
use Angelos::Config;

has 'components' => (
    is      => 'rw',
    default => sub { +{} },
);

no Mouse;

sub load_components {
    my ( $self, $class ) = @_;

    my @paths   = qw( ::Controller ::C ::Model ::M ::View ::V );
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { s/^(?=::)/$class/; $_; } @paths ], );

    my @comps = sort { length $a <=> length $b } $locator->plugins;
    my %comps = map { $_ => 1 } @comps;

    for my $component (@comps) {
        Mouse::load_class($component);

        my $module = $self->load_component($component);
        $self->_install_plugins_to($module);
        my %modules = (
            $component => $module,
            map { $_ => $self->load_component($_) }
                grep { not exists $comps{$_} }
                Devel::InnerPackage::list_packages($component)
        );

        for my $key ( keys %modules ) {
            $self->set_component( $key, $modules{$key} );
        }
    }
    $self->components;
}

sub _install_plugins_to {
    my ( $self, $component ) = @_;
    if ( $component =~ /Controller/i ) {
        $component->load_plugin( $_->{module} )
            for Angelos::Config->controller_plugins;
    } elsif ( $component =~ /View/i ) {
        $component->load_plugin( $_->{module} )
            for Angelos::Config->view_plugins;
    }
}

sub set_component {
    my ( $self, $key, $component ) = @_;
    $self->components->{$key} = $component;
}

sub get_component {
    my ( $self, $key ) = @_;
    $self->components->{$key};
}

sub load_component {
    my ( $self, $component ) = @_;

    my $suffix = Angelos::Utils::class2classsuffix($component);

    # FIXME: config loader
    my $config = {};
    my $instance = eval { $component->new( %{$config} || {} ) };

    if ( my $error = $@ ) {
        chomp $error;
        Angelos::Exception->throw( message =>
                qq/Couldn't instantiate component "$component", "$error"/ );
    }

    Angelos::Exception->throw( message =>
            qq/Couldn't instantiate component "$component", "COMPONENT() didn't return an object-like value"/
    ) unless Scalar::Util::blessed($instance);

    return $instance;
}

sub search_component {
    my ( $self, $name ) = @_;

    foreach my $component ( keys %{ $self->components } ) {
        return $self->get_component($component) if $component =~ /$name/i;
    }
    return undef;
}

sub search_model {
    my ( $self, $short_model_name ) = @_;
    $self->search_component( 'Model::' . $short_model_name );
}

sub search_controller {
    my ( $self, $short_controller_name ) = @_;
    $self->search_component( 'Controller::' . $short_controller_name );
}

sub search_view {
    my ( $self, $short_view_name ) = @_;
    $self->search_component( 'View::' . $short_view_name );
}

__PACKAGE__->meta->make_immutable;

1;

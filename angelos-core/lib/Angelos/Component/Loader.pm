package Angelos::Component::Loader;
use Angelos::Class;
use Module::Pluggable::Object;
use Angelos::Utils;
use Devel::InnerPackage;
use Angelos::Exceptions;
use Scalar::Util;
use Angelos::Config;
use Angelos::Registrar;

has 'components' => (
    is      => 'rw',
    default => sub { +{} },
);

with 'Angelos::Class::Configurable';
with 'Angelos::Class::ApplicationClassAware';

sub setup {
    my $self = shift;
    my $components = $self->load_components;
}

sub load_components {
    my ( $self, ) = @_;

    my @paths   = qw( ::Web::Controller ::Model ::Web::View  );
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { $self->application_class . $_ } @paths ], );

    my @comps = sort { length $a <=> length $b } $locator->plugins;
    my %comps = map { $_ => 1 } @comps;

    for my $component (@comps) {
        Mouse::load_class($component);

        my $module = $self->load_component($component);
        $self->_register_plugins_to($module);
        $module->SETUP if $module->can('SETUP');

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

sub _register_plugins_to {
    my ( $self, $component ) = @_;
    if ( $component =~ /Controller/i ) {
        $component->load_plugin( $_->{module} )
            for $self->config->plugins('controller');
    }
    elsif ( $component =~ /View/i ) {
        $component->load_plugin( $_->{module} )
            for $self->config->plugins('view');
    }
    elsif ( $component =~ /Model/i ) {
        $component->load_plugin( $_->{module} )
            for $self->config->plugins('model');
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
    my $config = $self->_get_component_config($component);
    my $instance = eval { $component->new( %{$config} ) };

    if ( my $error = $@ ) {
        chomp $error;
        Angelos::Exception->throw(
            message => "Couldn't instantiate component $component : $error" );
    }

    Angelos::Exception->throw(
        message => "Couldn't instantiate component $component" )
        unless Scalar::Util::blessed($instance);

    return $instance;
}

sub _get_component_config {
    my ( $self, $component ) = @_;
    my $suffix = Angelos::Utils::class2classsuffix($component);
    my ( $component_type, $class_suffix ) = split "::", $suffix;
    my $setting
        = $self->config->components( lc($component_type), $class_suffix );
    my $config = $setting->{config} || +{};
    $config;
}

sub search_component {
    my ( $self, $name ) = @_;

    foreach my $component ( keys %{ $self->components } ) {
        return $self->get_component($component) if $component =~ /$name/i;
    }
    Angelos::Exception::ComponentNotFound->throw(
        message => "component is't found: $name" );
}

sub search_model {
    my ( $self, $short_model_name ) = @_;
    my $appclass = $self->application_class;
    return $self->get_component(
        $appclass . "::Model::" . $short_model_name );
}

sub search_controller {
    my ( $self, $short_controller_name ) = @_;
    my $appclass = $self->application_class;
    return $self->get_component(
        $appclass . "::Web::Controller::" . $short_controller_name );
}

sub search_view {
    my ( $self, $short_view_name ) = @_;
    my $appclass = $self->application_class;
    return $self->get_component(
        $appclass . "::Web::View::" . $short_view_name );
}

__END_OF_CLASS__

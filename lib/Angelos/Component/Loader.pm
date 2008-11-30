package Angelos::Component::Loader;
use Moose;
use Module::Pluggable::Object;
use Angelos::Utils;
use Class::MOP;
use MooseX::AttributeHelpers;
use Devel::InnerPackage;
use Angelos::Exception;

has 'components' => (
    metaclass => 'Collection::Hash',
    is        => 'ro',
    isa       => 'HashRef',
    provides  => {
        'set' => 'set_component',
        'get' => 'get_component',
    },
    default => sub { +{} },
);

no Moose;

sub load_components {
    my ( $self, $class ) = @_;
    my @paths   = qw( ::Controller ::C ::Model ::M ::View ::V );
    my $locator = Module::Pluggable::Object->new(
        search_path => [ map { s/^(?=::)/$class/; $_; } @paths ], );

    my @comps = sort { length $a <=> length $b } $locator->plugins;
    my %comps = map { $_ => 1 } @comps;

    for my $component (@comps) {

        # We pass ignore_loaded here so that overlay files for (e.g.)
        # Model::DBI::Schema sub-classes are loaded - if it's in @comps
        # we know M::P::O found a file on disk so this is safe

        Angelos::Utils::ensure_class_loaded( $component,
            { ignore_loaded => 1 } );
        Class::MOP::load_class($component);

        my $module  = $self->load_component($component);
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
    ) unless blessed($instance);

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
    my ( $self, $short_model_name ) = @_;
    $self->search_component( 'Controller::' . $short_model_name );
}

sub search_view {
    my ( $self, $short_model_name ) = @_;
    $self->search_component( 'View::' . $short_model_name );
}

__PACKAGE__->meta->make_immutable;

1;

package Angelos::Component::Loader;
use Moose;
use Module::Pluggable::Object;

no Moose;

# need this method?
sub load {
}

sub load_controllers {
    my $self = shift;
    $self->_load_controllers('View');
}

sub load_views {
    my $self = shift;
    $self->_load_components('View');
}

sub load_models {
    my $self = shift;
    $self->_load_components('Model');
}

sub _load_components {
    my ( $self, $component_type ) = @_;

    # FIXME later
    my $search_path = '' . $component_type . '';
    $self->_load_modules($search_path);
}

sub _load_modules {
    my ( $self, $search_path ) = @_;
    my $loader = Module::Pluggable::Object->new(
        search_path => [ $search_path, ],
        require     => 1,
    );

    my $components = [];
    for my $component ( $loader->plugins ) {

        # FIXME pass configuration like plagger
        push @{$components}, $component->new();
    }
    $components;
}

__PACKAGE__->meta->make_immutable;

1;

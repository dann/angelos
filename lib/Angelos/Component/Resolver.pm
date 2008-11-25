package Angelos::Component::Resolver;
use Moose;

no Moose;

#FIXME move to Resolver
sub reslove_view_engine_name {

}

#FIXME move to Resolver
sub reslove_component_name {
    my ( $self, $component ) = @_;

    # FIXME
    die 'Implement me';
}

__PACKAGE__->meta->make_immutable;

1;

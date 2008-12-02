package Angelos::Dispatcher::Routes::Builder::Connect;
use Moose;
use String::CamelCase qw(camelize);
extends 'Angelos::Dispatcher::Routes::Builder::Base';

sub build {
    my ( $self, $route ) = @_;
    my $args = {};
    $args->{action}       = $route->{action};
    $args->{controller}   = camelize( $route->{controller} );
    $args->{conditions}   = $route->{conditions} || {};
    $args->{requirements} = $route->{requirements} || {};

    $self->build_route( $route->{path} => $args );
}

__PACKAGE__->meta->make_immutable;

1;

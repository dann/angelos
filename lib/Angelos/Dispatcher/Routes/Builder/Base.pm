package Angelos::Dispatcher::Routes::Builder::Base;
use Moose;

sub build_route {
    my ( $self, $path, $args ) = @_;

    $args ||= {};
    my $conditions   = delete $args->{conditions}   || {};
    my $requirements = delete $args->{requirements} || {};

    return HTTP::Router::Route->new(
        path         => $path,
        params       => $args,
        conditions   => $conditions,
        requirements => $requirements,
    );
}

__PACKAGE__->meta->make_immutable;

1;


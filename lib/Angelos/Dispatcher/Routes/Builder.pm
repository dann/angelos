package Angelos::Dispatcher::Routes::Builder;
use Mouse;
use Angelos::Config;
use HTTP::Router::Builder;

has 'builder' => (
    is      => 'rw',
    default => sub {
        HTTP::Router::Builder->new;
    },
);

no Mouse;

sub build_from_config {
    my $self = shift;
    $self->build( Angelos::Config->routes );
}

sub build {
    my ( $self, @routes_conf ) = @_;
    my $routes = [];
    foreach my $route (@routes_conf) {
        if ( $route->{type} eq 'connect' ) {
            push @{$routes}, $self->_build_connect($route);
        }
        elsif ( $route->{type} eq 'resource' ) {
            my $args = {};
            push @{$routes}, @{ $self->_build_resource($route) };
        }
        elsif ( $route->{type} eq 'resources' ) {
            my $args = {};
            push @{$routes}, @{ $self->_build_resources($route) };
        }
    }
    $routes;
}

sub _build_connect {
    my ( $self, $route ) = @_;
    my $args = {};
    $args->{action}       = delete $route->{action};
    $args->{controller}   = delete $route->{controller};
    $args->{conditions}   = delete $route->{conditions} || {};
    $args->{requirements} = delete $route->{requirements} || {};
    $self->builder->build_connect( $route->{path}, $args );
}

sub _build_resource {
    my ( $self, $route ) = @_;
    my $args = {};

    # FIXME
    $self->builder->build_resource( $route->{controller}, $args );
}

sub _build_resources {
    my ( $self, $route ) = @_;
    my $args = {};

    # FIXME
    $self->builder->build_resources( $route->{controller}, $args );
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

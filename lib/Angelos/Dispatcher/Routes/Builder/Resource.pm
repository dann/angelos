package Angelos::Dispatcher::Routes::Builder::Resource;
use Mouse;
use String::CamelCase qw(camelize);
extends 'Angelos::Dispatcher::Routes::Builder::Base';

sub build {
    my ( $self, $route ) = @_;
    my $routes = [];
    push @{$routes}, $self->_build_index_route($route);
    push @{$routes}, $self->_build_create_route($route);
    push @{$routes}, $self->_build_new_route($route);
    push @{$routes}, $self->_build_edit_route($route);
    push @{$routes}, $self->_build_show_route($route);
    push @{$routes}, $self->_build_update_route($route);
    push @{$routes}, $self->_build_destroy_route($route);
    $routes;
}

sub _build_index_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller};
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'index';
    $args->{conditions} = { method => ['GET'] };
    $self->build_route( $path => $args );
}

sub _build_create_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller};
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'create';
    $args->{conditions} = { method => ['POST'] };
    $self->build_route( $path => $args );
}

sub _build_new_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller} . '/new';
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'new';
    $args->{conditions} = { method => ['POST'] };
    $self->build_route( $path => $args );
}

sub _build_edit_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller} . '/{id}/edit';
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'edit';
    $args->{conditions} = { method => ['GET'] };
    $self->build_route( $path => $args );
}

sub _build_show_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller} . '/{id}';
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'show';
    $args->{conditions} = { method => ['GET'] };
    $self->build_route( $path => $args );
}

sub _build_update_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller} . '/{id}';
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'update';
    $args->{conditions} = { method => ['PUT'] };
    $self->build_route( $path => $args );
}

sub _build_destroy_route {
    my ( $self, $route ) = @_;
    my $path = '/' . $route->{controller} . '/{id}';
    my $args = {};
    $args->{controller} = camelize( $route->{controller} );
    $args->{action}     = 'destroy';
    $args->{conditions} = { method => ['DELETE'] };
    $self->build_route( $path => $args );
}

__PACKAGE__->meta->make_immutable;

1;

package Angelos::PSGI::Adapter;
use strict;
use warnings;
use UNIVERSAL::require;

sub new {
    my ( $class, $app ) = @_;
    bless { app => $app }, $class;
}

sub handler {
    my $self = shift;
    my $app  = $self->_new_app;
    return sub { $app->run };
}

sub _new_app {
    my $self = shift;
    my $app  = $self->{app};
    $app->require;
    $app->new;
}

1;

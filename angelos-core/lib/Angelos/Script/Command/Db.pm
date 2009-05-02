package Angelos::Script::Command::Db;
use strict;
use warnings;
use base qw(Angelos::Script::Command);
use Carp ();
use Path::Class;
use Mouse;
use DBIx::Class::Schema::Loader qw/make_schema_at/;
use lib 'lib';

=head1 NAME

Angelos::Script::Command::Db - db command 

=head1 DESCRIPTION

    Setup database
       % angelos db --setup 

    Generate Schema
       % angelos db --gen --app_class MyApp

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return (
        [ "setup",           "create database?" ],
        [ "gen", "generate schema?" ],
        [ "app_class=s",     "app_class" ],
    );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    #FIXME move to base class
    $self->setup_context($opt->{app_class});
    $self->generate_schema($opt) if $opt->{'gen'};
    $self->setup_database($opt)  if $opt->{'setup'};
}

sub generate_schema {
    my ( $self, $opt ) = @_;
    my $app_class = $opt->{app_class};
    Carp::croak 'app_class option must be set to generate schema'
        unless $app_class;

    my $connect_info = $self->_get_connect_info($app_class);
    make_schema_at(
        "${app_class}::Schema",
        {   components => [ ],
            dump_directory        => dir( 'lib' ),
            really_erase_my_files => 1,
            debug                 => 1,
        },
        $connect_info,
    );

}

sub setup_database {
    die 'Implement me';
}

sub _get_connect_info {
    my ( $self, $app_class ) = @_;
    my $config = $self->_create_config($app_class);
    Carp::croak 'database section must be set in config'
        unless $config->database;
    Carp::croak 'master config is needed' unless $config->database->{master};
    my $connect_info = $config->database->{master}->{connect_info};
    Carp::croak 'connect_info must be set to generate schema'
        unless $connect_info;
    $connect_info;
}

sub _create_config {
    my ( $self, $app_class ) = @_;
    my $config_class = "${app_class}::Config";
    Mouse::load_class($config_class);
    $config_class->instance;
}

# FIXME refactor context from app  and create context class or remove context
# class
sub _create_app {
    my ($self, $app_class) = @_;
    Mouse::load_class($app_class);
    my $app = $app_class->new(
        host   => 'localhost',
        port   => '3001',
        server => 'ServerSimple',
        debug  => 0,
    );
    $app;
}

sub setup_context {
    my ($self, $app_class) = @_;
    my $app = $self->_create_app($app_class);
    local *Angelos::Registrar::context = sub {$app};
}

1;

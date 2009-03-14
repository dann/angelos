package Angelos::Script::Command::Db;
use strict;
use warnings;
use base qw(Angelos::Script::Command);
use Carp ();
use Path::Class;
use DBIx::Class::Schema::Loader qw/make_schema_at/;
use lib 'lib';

=head1 NAME

Angelos::Script::Command::Db - db command 

=head1 DESCRIPTION

    % angelos db --setup 
    % angelos db --generate_schema --app_class MyApp

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return (
        [ "setup",           "create database?" ],
        [ "generate_schema", "generate schema?" ],
        [ "app_class=s",     "app_class" ],
    );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    $self->generate_schema($opt) if $opt->{'generate_schema'};
    $self->setup_database($opt)  if $opt->{'setup'};
}

sub generate_schema {
    my ( $self, $opt ) = @_;
    my $app_class = $opt->{app_class};
    Carp::croak 'app_class option must be set to generate schema'
        unless $app_class;

    my $erase = $opt->{erase} || 0;
    my $connect_info = $self->_get_connect_info($app_class);
    make_schema_at(
        "${app_class}::Schema",
        {   components => [ 'ResultSetManager', 'UTF8Columns' ],
            dump_directory        => dir( $FindBin::Bin, '..', 'lib' ),
            really_erase_my_files => $erase,
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

1;

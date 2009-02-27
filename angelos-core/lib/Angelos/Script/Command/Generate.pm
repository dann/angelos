package Angelos::Script::Command::Generate;
use strict;
use warnings;
use base qw(Angelos::Script::Command);
use Module::Setup;
use Path::Class;
use Carp ();
use String::CamelCase qw(camelize);
use Angelos::Exceptions;

=head1 NAME

Angelos::Script::Command::Generate - A generator for your Angelos application

=head1 DESCRIPTION

    % bin/angelos generate [--flavor app] --name MyApp 

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return ( [ "flavor=s", "flavor name" ], [ "name=s", "name" ], );
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    my $flavor = $opt->{flavor} || 'app';
    my $module = $opt->{name};

    $self->generate( $flavor, $module );

    my $module_dir = dir( split '::', $module );
    $self->make_scripts_executable($module);
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
    my $module = $opt->{name};

    Carp::croak "You need to give your new module name --name" unless $module;
}

sub generate {
    my ( $self, $flavor, $module ) = @_;
    my $flavor_class = $self->to_flavor_class($flavor);
    $self->system( 'module-setup', '--direct',
        '--flavor-class=+' . $flavor_class, $module );
}

sub make_scripts_executable {
    my ( $self, $module_dir ) = @_;

    my @scripts = (
        dir( $module_dir, 'bin' )->children,
        dir( $module_dir, 'tools' )->children
    );
    for my $script (@scripts) {
        $self->system( 'chmod', '755', $script );
    }
}

sub to_flavor_class {
    my ( $self, $flavor_type ) = @_;
    "Angelos::Script::Command::Generate::Flavor::" . camelize($flavor_type);
}

1;

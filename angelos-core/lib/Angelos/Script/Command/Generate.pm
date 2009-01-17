package Angelos::Script::Command::Generate;
use strict;
use warnings;
use base qw(Angelos::Script::Command);
use Module::Setup;
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
    return (
        [ "flavor=s", "flavor name" ],
        [ "name=s",   "name" ],
    );
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    my $flavor = $opt->{flavor} || 'app';
    my $module = $opt->{name};
    
    $self->generate( $flavor, $module );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
    my $module = $opt->{name};

    Angelos::Exception::ParameterMissingError->throw(
        message => "You need to give your new module name --name\n")
        unless $module;
}

sub generate {
    my ( $self, $flavor, $module ) = @_;
    my $flavor_class = $self->to_flavor_class($flavor);
    $self->system('module-setup', '--direct', '--flavor-class=+' . $flavor_class, $module); 
}

sub to_flavor_class {
    my ( $self, $flavor_type ) = @_;
    "Angelos::Script::Command::Generate::Flavor::" . camelize($flavor_type);
}

1;

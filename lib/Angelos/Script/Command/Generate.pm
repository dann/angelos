package Angelos::Script::Command::Generate;
use base qw(App::Cmd::Command);
use Mouse;
use Module::Setup;
use String::CamelCase qw(camelize);
use Angelos::Exceptions;

no Mouse;

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
        "You need to give your new module name --module\n")
        unless $module;
}

sub generate {
    my ( $self, $flavor, $module ) = @_;
    local $ENV{MODULE_SETUP_DIR} = '/tmp/module-setup';
    my $plugins      = [];
    my $flavor_class = $self->to_flavor_class($flavor);
    my $options      = {
        module       => $module,
        plugins      => $plugins,
        flavor_class => $flavor_class,
        direct       => 1,
    };
    my $argv = [$module];
    my $pmsetup = Module::Setup->new( options => $options, argv => $argv );
    $pmsetup->run( $options, [ $module, $flavor_class ] );
}

sub to_flavor_class {
    my ( $self, $flavor_type ) = @_;
    "+Angelos::Script::Command::Generate::Flavor::" . camelize($flavor_type);
}

1;

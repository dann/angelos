package Angelos::Script::Gen;
use base qw(App::CLI::Command);
use Mouse;
use Module::Setup;
use String::CamelCase qw(camelize);
use Angelos::Exceptions;

no Mouse;

=head1 NAME

Angelos::Script::Gen - A generator for your Angelos application

=head1 DESCRIPTION

    % bin/angelos gen [--flavor app] --name MyApp 

=head1 METHODS

=head2 options()

=cut

sub options {
    (   'f|flavor=s' => 'flavor',
        'm|name=s'   => 'name',
        'js'         => 'js',
    );
}

sub run {
    my $self   = shift;
    my $flavor = $self->{flavor} || 'app';
    my $module = $self->{name};

    $self->validate_options;

    $self->generate( $flavor, $module );
}

sub validate_options {
    my $self   = shift;
    my $flavor = $self->{flavor} || 'app';
    my $module = $self->{name};

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
    "+Angelos::Script::Gen::Flavor::" . camelize($flavor_type);
}

1;

package Angelos::Script::Generate;
use Mouse;
use Module::Setup;
use String::CamelCase qw(camelize);
extends 'Angelos::Script';

no Mouse;

sub run {
    my ( $class, $flavor_type, $module ) = @_;

    local $ENV{MODULE_SETUP_DIR} = '/tmp/module-setup';
    my $plugins      = [];
    my $flavor_class = $class->to_flavor_class($flavor_type);
    my $options = {
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
    my ( $class, $flavor_type ) = @_;
    "+Angelos::Script::Generate::Flavor::" . camelize($flavor_type);
}

1;

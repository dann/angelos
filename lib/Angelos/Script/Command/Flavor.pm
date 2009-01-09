package Angelos::Script::Command::Flavor;
use base qw(App::Cmd::Command);
use Path::Class;
use String::CamelCase qw(camelize);
use Angelos::Exceptions;
use IPC::System::Simple qw(system capturex);

=head1 NAME

Angelos::Script::Command::Flavor - A flavor packer/unpacker (for angelos developer only)

=head1 DESCRIPTION

    % angelos flavor --name app --pack 
    % angelos flavor --name app --unpack 

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return (
        [ "name=s", "flavor name" ],
        [ "pack",   "pack flavor?" ],
        [ "unpack", "unpack flavor?" ],
    );
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    my $flavor = $opt->{name} || 'app';

    $self->pack_flavor($flavor)   if $opt->{'pack'};
    $self->unpack_flavor($flavor) if $opt->{'unpack'};
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;

    my $flavor = $opt->{name};
    die "You need to give flavor name with name option\n" unless $flavor;

    my $pack   = $opt->{'pack'};
    my $unpack = $opt->{'unpack'};

    die "You need to give pack or unpack option\n"
        unless $pack
            or $unpack;
}

sub pack_flavor {
    my ( $self, $flavor ) = @_;
    local $ENV{MODULE_SETUP_DIR} = dir( $ENV{HOME}, '.angelos' );
    my $flavor_path  = $self->to_flavor_path($flavor);
    my $flavor_class = $self->to_flavor_class($flavor);
    die "$flavor_path doesn't exist" unless -f $flavor_path;
    $flavor_path->remove;
    my $output
        = capturex( "module-setup", "--pack", "$flavor_class", $flavor );
    my $fh = $flavor_path->openw;
    $fh->print($output);
    $fh->close;
}

sub unpack_flavor {
    my ( $self, $flavor ) = @_;
    local $ENV{MODULE_SETUP_DIR} = dir( $ENV{HOME}, '.angelos' );
    my $flavor_class = "+" . $self->to_flavor_class($flavor);
    system( "module-setup", "--init", "--flavor-class=$flavor_class",
        $flavor );
}

sub to_flavor_path {
    my ( $self, $flavor_type ) = @_;
    my $flavor_path
        = file( "lib", "Angelos", "Script", "Command", "Generate", "Flavor",
        camelize($flavor_type) . ".pm" );
    $flavor_path;
}

sub to_flavor_class {
    my ( $self, $flavor_type ) = @_;
    "Angelos::Script::Command::Generate::Flavor::" . camelize($flavor_type);
}

1;

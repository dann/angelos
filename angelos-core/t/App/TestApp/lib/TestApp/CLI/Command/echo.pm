package TestApp::CLI::Command::echo;
use base 'Angelos::CLI::Command';
use Angelos::Config;
use Data::Dumper;

=head1 NAME
 
TestApp::CLI::Command::echo - echo carguments ommand
 
=cut

sub opt_spec {
    return (
        [ "blortex|X", "use the blortex algorithm" ],
        [ "recheck|r", "recheck all results" ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;
    # no args allowed but options!
    $self->usage_error("No args allowed") if @$args;
}

sub run {
    my ( $self, $opt, $args ) = @_;
    my $result = $opt->{blortex};
    print $result . "\n";
}

1;

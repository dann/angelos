package TestApp::CLI::Command::Echo;
use base qw(Angelos::CLI::Command);

=head1 NAME

TestApp::CLI::Command::Echo - echo command 

=head1 DESCRIPTION

    % cli echo --name Yamada  

=cut

sub opt_spec {
    return (
        [ "name=s", "your name" ],
    );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;

    return if $opt->{name};

    my $name = $opt->{name};
    die "You need to give your name with name option\n"
        unless $name;
}

sub run {
    my ( $self, $opt, $arg ) = @_;
    my $name = $opt->{name};
    print $name . "\n";
}

1;

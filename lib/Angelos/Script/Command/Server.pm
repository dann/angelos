package Angelos::Script::Command::Server;
use base qw(App::Cmd::Command);
use UNIVERSAL::require;
use Angelos::Exceptions;

=head1 NAME

Angelos::Script::Command::Server - A server script

=head1 DESCRIPTION

=head1 METHODS


=cut

sub opt_spec {
    return (
        [ "app_class=s", "enable foo-bar subsystem" ],
        [ "host=s",       "host name" ],
        [ "server=s",     "server module" ],
        [ "port=s",       "port number" ],
    );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
    my $app = $opt->{app_class};
    Angelos::Exception::ParameterMissingError->throw(
        "You need to give your application name --app\n")
        unless $app;

}

sub run {
    my ( $self, $opt, $arg ) = @_;
    my $app = $opt->{app_class};
    $app->require;
    $app = $app->new(
        host   => $self->{host}   || '127.0.0.1',
        port   => $self->{port}   || 3000,
        server => $self->{server} || 'ServerSimple',
    );
    $app->setup;
    $app->run;
}

1;

package Angelos::Script::Server;
use base qw(App::CLI::Command);
use UNIVERSAL::require;

=head1 NAME

Angelos::Script::Server - A server script

=head1 DESCRIPTION

=head1 METHODS

=head2 options()

=cut

sub options {
    (   'app_class=s' => 'app',
        'host=s'      => 'host',
        'server=s'    => 'server',
        'port=s'      => 'port',
    );
}

sub run {
    my $self = shift;
    $self->validate_options;
    $self->run_server; 
}

sub run_server {
    my $self = shift;
    my $app  = $self->{app_class};
    $app->require;
    $app = $app->new(
        host   => $self->{host}   || '127.0.0.1',
        port   => $self->{port}   || 3000,
        server => $self->{server} || 'ServerSimple',
    );
    $app->setup;
    $app->run;
}

sub validate_options {
    my $app  = $self->{app_class};
    Angelos::Exception::ParameterMissingError->throw(
        "You need to give your application name --app\n")
        unless $app;

}

1;

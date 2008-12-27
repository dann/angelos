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
    (   'app=s'    => 'app',
        'host=s'   => 'host',
        'server=s' => 'server',
        'port=s'   => 'port',
    );
}

sub run {
    my $self = shift;
    my $app  = $self->{app};

    # App::CLI bug
    if($self->{app} eq 'Angelos::Script') {
        die "You need to give your application name --app\n";
    }

    die "You need to give your application name --app\n"
      unless $app =~ /\w+/;

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

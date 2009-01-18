package Angelos::Controller::Plugin::ActionProfiler;
use Angelos::Plugin;
use Time::HiRes qw(time);

has '__action_start_time' => ( is => 'rw', );

has '__action_end_time' => ( is => 'rw', );

after 'SETUP' => sub {
    my $self = shift;

    my $config = $self->config->plugins('controller', 'ActionProfiler');
    use Data::Dumper;
    warn Dumper $config;
};

before 'ACTION' => sub {
    my ( $self, $c, $action, $params ) = @_;
    $self->__action_start_time( time() );
};

after 'ACTION' => sub {
    my ( $self, $c, $action, $params ) = @_;
    $self->__action_end_time( time() );

    my $elapsed = $self->__action_end_time - $self->__action_start_time;
    my $message
        = "action processing time:\naction: $action \ntime  : $elapsed  secs\n";
    $self->log(
        level   => 'info',
        message => $message,
    );
};

1;

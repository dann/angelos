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

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

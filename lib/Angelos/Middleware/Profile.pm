package Angelos::Middleware::Profile;
use Mouse;
use Time::HiRes qw(time);
extends 'Angelos::Middleware';

sub wrap {
    my $self = shift;

    sub {
        my $req        = shift;
        my $start_time = time();
        my $res        = $self->handler->($req);
        my $end_time   = time();

        # use logger
        warn "Request handling time: \n";
        warn $end_time - $start_time . " secs";
        $res;
    }
}

1;

package Angelos::Middleware::Profile;
use Mouse;
use Time::HiRes qw(time);
extends 'Angelos::Middleware';

no Mouse;

sub wrap {
    my ($self, $next)  = @_;

    sub {
        my $req        = shift;
        my $start_time = time();
        my $res        = $next->($req);
        my $end_time   = time();

        # use logger
        warn "Request handling time: \n";
        warn $end_time - $start_time . " secs";
        $res;
    }
}

__PACKAGE__->meta->make_immutable;

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

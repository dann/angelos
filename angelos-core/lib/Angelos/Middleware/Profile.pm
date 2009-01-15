package Angelos::Middleware::Profile;
use Mouse;
use Time::HiRes qw(time);
extends 'Angelos::Middleware';

no Mouse;

sub wrap {
    my ( $self, $next ) = @_;

    sub {
        my $req = shift;
        my $res = $self->profile( $next, $req );
        $res;
        }
}

sub profile {
    my ( $self, $code, $args ) = @_;
    my $start_time = time();
    my $result     = $code->($args);
    my $end_time   = time();
    my $elapsed    = $end_time - $start_time;
    my $message    = "Request handling time: \n" . $elapsed . " secs";
    $self->log( level => 'info', message => $message );
    $result;
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

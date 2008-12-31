package Angelos::Middleware;
use Mouse;
use Angelos::Exceptions;
use Angelos::Logger;

no Mouse;

sub wrap {
    my ( $self, $next ) = @_;
    Angelos::Exception::AbstractMethod->throw(
        'Sub class must implement wrap method');
}

sub log_message {
    my ( $self, $message ) = @_;
    Angelos::Logger->instance->log(
        level   => "info",
        message => "\n" . $message,
    );
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

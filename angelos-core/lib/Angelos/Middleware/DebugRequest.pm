package Angelos::Middleware::DebugRequest;
use Angelos::Class;
use Angelos::Utils;
extends 'HTTP::Engine::Middleware::DebugRequest';

sub log {
    my ($self, $message) = @_;
    Angelos::Utils::context()->logger->info($message);
}

__END_OF_CLASS__

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 CONTRIBUTORS

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package Angelos::Middleware::DebugScreen;
use Angelos::Class;
extends 'HTTP::Engine::Middleware::DebugScreen';

has 'powered_by' => (
    +default => sub {
        'Angelos ';
    }
);

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

package Angelos::Middleware::Unicode;
use Angelos::Class;
use utf8;

sub wrap {
    my ( $self, $next ) = @_;
    sub {
        my $req = shift;
        $self->decode_params($req);
        my $res = $next->($req);
        $self->encode_body($res);
        $res;
    }
}

sub encode_body {
    my ( $self, $response ) = @_;

    if ( $response->body && utf8::is_utf8( $response->body ) ) {
        utf8::encode( $response->body );
    }
}

sub decode_params {
    my ( $self, $request ) = @_;
    for my $value ( values %{ $request->parameters } ) {
        if ( ref $value && ref $value ne 'ARRAY' ) {
            next;
        }
        utf8::decode($_) for ( ref($value) ? @{$value} : $value );
    }
}

__END_OF_CLASS__

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

package Angelos::Middleware::Unicode;
use Mouse;
use utf8;

no Mouse;

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
    for my $value ( values %{ $request->params } ) {
        if ( ref $value && ref $value ne 'ARRAY' ) {
            next;
        }
        utf8::decode($_) for ( ref($value) ? @{$value} : $value );
    }
}

__PACKAGE__->meta->make_immutable;

1;


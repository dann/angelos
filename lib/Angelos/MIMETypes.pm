package Angelos::MIMETypes;
use Mouse;
use MIME::Types;
use MIME::Type;

has 'types' => (
    is      => 'rw',
    default => sub {
        MIME::Types->new;
    },
);

no Mouse;

sub mime_type_of {
    my ( $self, $ext ) = @_;
    if ( UNIVERSAL::isa( $ext, 'URI' ) ) {
        $ext = ( $ext->path =~ /\.(\w+)$/ )[0];
    }
    $self->types->mimeTypeOf($ext);
}

sub add_type {
    my ( $self, $type, $extensions ) = @_;
    $self->types->add_type(
        MIME::Type->new(
            type      => $type,
            extension => $extensions,
        )
    );
}

__PACKAGE__->meta->make_immutable;

1;

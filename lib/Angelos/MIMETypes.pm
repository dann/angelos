package Angelos::View::MIMETypes;
use Moose;
use MIME::Types;
use MIME::Type;

has 'types' => (
    is      => 'rw',
    default => sub {
        my $mimetypes = MIME::Types->new;
        $mimetypes->addType(
            MIME::Type->new(
                type       => 'video/x-matroska',
                extensions => ['mkv']
            )
        );
        $mimetypes;
    }
);

no Moose;

sub mime_type_of {
    my ( $self, $ext ) = @_;
    if ( UNIVERSAL::isa( $ext, 'URI' ) ) {
        $ext = ( $ext->path =~ /\.(\w+)$/ )[0];
    }
    $self->types->mimeTypeOf($ext);
}

__PACKAGE__->meta->make_immutable;

1;

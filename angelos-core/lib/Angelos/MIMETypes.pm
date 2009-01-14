package Angelos::MIMETypes;
use Mouse;

has 'types' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {
        {   css  => 'text/css',
            gif  => 'image/gif',
            jpeg => 'image/jpeg',
            jpg  => 'image/jpeg',
            js   => 'application/javascript',
            png  => 'image/png',
            txt  => 'text/plain',
            html => 'text/html',
            htm  => 'text/html',
            json => 'application/json',
            rss  => 'application/xml',
            atom => 'application/xml',
        };
    }
);

no Mouse;

sub mime_type_of {
    my ( $self, $ext ) = @_;
    $self->types->{$ext} || 'text/plain';
}

sub add_type {
    my ( $self, $type, $extension ) = @_;
    $self->types->{$type} = $extension;
}

__PACKAGE__->meta->make_immutable;

1;

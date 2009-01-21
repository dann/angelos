package Angelos::MIMETypes;
use Angelos::Class;

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

sub mime_type_of {
    my ( $self, $ext ) = @_;
    $self->types->{$ext};
}

sub add_type {
    my ( $self, $ext, $mime_type ) = @_;
    $self->types->{$ext} = $mime_type;
}

__END_OF_CLASS__


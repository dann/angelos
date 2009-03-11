package Angelos::MIMETypes;
use Angelos::Class;
use MouseX::AttributeHelpers;

has 'types' => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef',
    default   => sub {
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
    },
    provides => {
        'set' => 'add_type',
        'get' => 'mime_type_of',
    }
);

__END_OF_CLASS__


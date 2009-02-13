package Angelos::Controller::Mixin::Responder;
use Any::Moose '::Role';
use Angelos::MIMETypes;
use Angelos;

has '__contenttype_to_view_mappings' => (
    is      => 'rw',
    default => sub {
        {   'text/html'        => 'TT',
            'application/json' => 'JSON',
        },
    }
);

sub __content_type {
    my ( $self, ) = @_;
    my $content_type ||= $self->__content_type_from_format;
    $content_type    ||= $self->__content_type_from_accept_header;
    $content_type    ||= 'text/html';
    $content_type;
}

sub __content_type_from_format {
    my $self = shift;
    my $format ||= $self->context->_match->{format};
    Angelos->available_mimetypes->mime_type_of($format);
}

sub __content_type_from_accept_header {
    my $self    = shift;
    my @accepts = $self->req->header('Accept');
    return $accepts[0] if @accepts;
}

sub __select_view {
    my ( $self, $content_type ) = @_;
    my $view = $self->__contenttype_to_view_mappings->{$content_type};
    $view ||= 'TT';
    $view;
}

sub render {
    my ( $self, @args ) = @_;
    my $content_type    = $self->__content_type;
    my $view_class_name = $self->__select_view($content_type);
    $self->view($view_class_name)->render(@args);
}

1;

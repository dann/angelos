package Angelos::Controller::Mixin::Responder;
use Mouse::Role;
use Angelos::MIMETypes;
use Angelos;

has '__contenttype_to_view_mappings' => (
    is      => 'rw',
    default => sub {
        'text/html' => 'View::TT',
    }
);

sub __content_type {
    my ( $self, ) = @_;
    my $format ||= $self->context->_match->{format};
    $format    ||= $self->__negotiate_content_type;
    $format    ||= 'html';
    Angelos->available_mimitypes->mime_type_of($format);
}

# TODO content type from header
sub __negotiate_content_type {
    my $self = shift;
    #$self->request->header();
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

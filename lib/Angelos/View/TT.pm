package Angelos::View::TT;
use Mouse;
use Template;
use Angelos::Home;
extends 'Angelos::View';

has 'engine' => (
    is      => 'rw',
    default => sub {
        my $self = shift;
        Template->new( INCLUDE_PATH => $self->root );
    }
);

has 'TEMPLATE_EXTENSION' => ( +default => '.tt' );
has 'CONTENT_TYPE' => ( +default => 'text/html' );

no Mouse;

sub _render {
    my ( $self, $c, $vars ) = @_;
    $self->engine->process( $c->stash->{template} . $self->TEMPLATE_EXTENSION,
        $vars, \my $out );
    if ( $self->engine->error ) {
        my $error
            = "Couldn't render template "
            . $c->stash->{template} . ": "
            . $self->engine->error;
        $c->log( error => $error );
    }
    $out;
}

__PACKAGE__->meta->make_immutable;

1;

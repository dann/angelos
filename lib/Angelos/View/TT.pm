package Angelos::View::TT;
use Mouse;
use Template;
use Angelos::Home;
extends 'Angelos::View';

has 'engine' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_engine',
 
);

has 'TEMPLATE_EXTENSION' => ( +default => '.tt' );
has 'CONTENT_TYPE' => ( +default => 'text/html' );

has 'INCLUDE_PATH' => (
    is => 'rw',
    default => sub {
        my $self = shift;
        $self->root;
    }
);

no Mouse;

sub build_engine {
    my $self = shift;
    Template->new( INCLUDE_PATH => $self->INCLUDE_PATH );
}

sub _render {
    my ( $self, $c, $vars ) = @_;
    $self->engine->process( $c->stash->{template} . $self->TEMPLATE_EXTENSION,
        $vars, \my $out );
    if ( $self->engine->error ) {
        my $error
            = "Couldn't render template "
            . $c->stash->{template} . ": "
            . $self->engine->error;
        $c->log( $error );
    }
    $out;
}

__PACKAGE__->meta->make_immutable;

1;

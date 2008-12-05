package Angelos::View::Engine::TT;
use Mouse;
use Template;
extends 'Angelos::View::Engine';

no Mouse;

sub build_engine {
    my $self = shift;
    Template->new( INCLUDE_PATH => $self->{INCLUDE_PATH} );
}

sub render {
    my ( $self, $c, $vars ) = @_;
    $self->engine->process( $c->stash->{template}, $vars, \my $out );
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

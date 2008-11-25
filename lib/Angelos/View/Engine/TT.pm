package Angelos::View::Engine::TT;
use Moose;
use Template;
extends 'Angelos::View::Engine';

no Moose;

sub build_engine {
    my $self = shift;
    Template->new( INCLUDE_PATH => $self->{INCLUDE_PATH} );
}

sub render_template {
    my ( $self, $template, $stash, $args ) = @_;
    $self->engine->render( $template, $stash, \my $out )
        or die $self->engine->error;
    $out;
}

__PACKAGE__->meta->make_immutable;

1;

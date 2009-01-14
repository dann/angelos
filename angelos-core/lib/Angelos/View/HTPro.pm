package Angelos::View::HTPro;
use Mouse;
use Angelos::Home;
use HTML::Template::Pro;
use Path::Class;
extends 'Angelos::View';

has 'TEMPLATE_EXTENSION' => ( +default => '.tmpl' );
has 'CONTENT_TYPE'       => ( +default => 'text/html' );

no Mouse;

sub _build_engine {
}

sub _render {
    my ( $self, $c, $vars ) = @_;
    my $template_path = file( $self->root, $c->stash->{template} );
    my $template = HTML::Template::Pro->new( filename => "$template_path" );
    foreach my $key ( keys %{$vars} ) {
        $template->param( $key => $vars->{$key} );
    }
    my $out = $template->output;
    $out;
}

__PACKAGE__->meta->make_immutable;

1;

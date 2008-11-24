package Angelos::View;
use Moose;
use Angelos::View::Engine::TT;

with 'MooseX::Object::Pluggable', 'Angelos::Component';

has 'engine' => (
    isa     => 'Angelos::View::Engine',
    default => sub {
        # FIXME
        Angelos::View::Engine::TT->new;
    }
);

no Moose;

sub render {
    my ( $self, $c ) = @_;
    $self->engine->render($c);
}

__PACKAGE__->meta->make_immutable;

1;

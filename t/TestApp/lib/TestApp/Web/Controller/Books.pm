package TestApp::Web::Controller::Books;
use Mouse;
extends 'Angelos::Controller';

sub index {
    my ($self, $c) = @_;
    warn 'coooooooooooool';
    $self->dump($c);
    $c->res->body('Hello world in Book controller');
    $c->res->code(200);
}

__PACKAGE__->meta->make_immutable;

1;

package TestApp::Web::Controller::BookStore;
use Mouse;
extends 'Angelos::Controller';

sub list_books {
    my ($self, $c) = @_;
    $c->model('BookStore')->list_books;
    
}

__PACKAGE__->meta->make_immutable;

1;

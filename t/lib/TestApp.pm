package TestApp;
use Moose;
use Path::Dispatcher::Rule::Tokens;
use Path::Dispatcher::Rule::Regex;
extends 'Angelos';

sub build_dispatch_rules {
    my $self       = shift;

    my $controller = $self->controller('Root');
    my $rule1      = Path::Dispatcher::Rule::Tokens->new(
        tokens => ['index'],
        block => sub {
            my $c = shift;
            $controller->index($c);
        },
    );
    my $bookstore_controller = $self->controller('BookStore');
    my $rule2                = Path::Dispatcher::Rule::Regex->new(
        regex => qr{^/bookstore/list_books},
        block => sub {
            my $c = shift;
            $bookstore_controller->list_books($c);
        },
    );
    my $rules= [ $rule1, $rule2 ];
    $rules;
}

__PACKAGE__->meta->make_immutable;

1;

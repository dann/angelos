package TestApp;
use Moose;
extends 'Angelos';

sub build_dispatch_rules {
    my $self       = shift;
    my $controller = $self->controller('Basic');
    my $rule       = Path::Dispatcher::Rule::Regex->new(
        regex => qr{^/index/},
        block => sub {
            my $c = shift;
            $controller->index($c);
        },
    );
    [$rule];
}

__PACKAGE__->meta->make_immutable;

1;

package TestApp::Web::Controller::MiddlewareUnicode;
use Mouse;
extends 'Angelos::Controller';

no Mouse;

sub index {
    my ( $self, $c, $params ) = @_;
    my $name = $c->req->param('name');
    $c->log( level => 'debug', message => $name );
    die "this isn't utf8 flagged" unless utf8::is_utf8($name);

    # must not reach here because we use Unicode middleware
    $c->res->code(200);
    $c->res->body('HelloWorld');
}

__PACKAGE__->meta->make_immutable;

1;

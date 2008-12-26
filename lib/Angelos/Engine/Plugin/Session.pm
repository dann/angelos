package Angelos::Engine::Plugin::Session;
use Angelos::Class::Hookable::Plugin;
use Angelos::Config;
use Angelos::SessionBuilder;

hook 'BEFORE_DISPATCH' => sub {
    my ( $self, $c ) = @_;
    my $session = Angelos::SessionBuilder->new->build( $c->req );
    $c->session($session);
};

hook 'AFTER_DISPATCH' => sub {
    my ( $self, $c ) = @_;
    $c->session->response_filter( $c->res );
    $c->session->finalize;
};

1;

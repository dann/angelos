package Angelos::Engine::Plugin::Session;
use MouseX::Plaggerize::Plugin;
use Angelos::Config;
use Angelos::Session::Builder;

hook 'BEFORE_DISPATCH' => sub {
    my ($self, $app, $c) = @_;
    warn 'BEFORE_DISPATCH';

    my $session = Angelos::Session::Builder->new->construct_session($c);
    $c->session($session);
};

hook 'AFTER_DISPATCH' => sub {
    my ($self, $app, $c) = @_;

    warn 'AFTER_DISPATCH';
    $c->session->response_filter($c->res);
    $c->session->finalize;
};

1;

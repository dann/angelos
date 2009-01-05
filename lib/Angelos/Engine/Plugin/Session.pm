package Angelos::Engine::Plugin::Session;
use Angelos::Plugin;
use Angelos::Config;
use Angelos::Engine::Plugin::Session::Builder;

around 'DISPATCH' => sub {
    my $orig = shift;
    my ($self, $c, $req) = @_;
    my $session = Angelos::Engine::Plugin::Session::Builder->new->build( $c->req );
    $c->session($session);

    my $result = $orig->($self, $c, $req);

    $c->session->response_filter( $c->res );
    $c->session->finalize;

    $result;
};

1;
__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

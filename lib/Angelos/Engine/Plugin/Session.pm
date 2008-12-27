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

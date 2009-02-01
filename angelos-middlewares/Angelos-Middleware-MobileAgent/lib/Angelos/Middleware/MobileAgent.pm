package HTTP::Engine::Middleware::MobileAgent;
use HTTP::Engine::Middleware;
use HTTP::MobileAgent;

middleware_method 'mobile_agent' => sub {
    my $self = shift;
    $self->{mobile_agent} ||= HTTP::MobileAgent->new($self);
};

__MIDDLEWARE__

__END__
__MIDDLEWARE__

__END__

=head1 NAME

Angelos::Middleware::MobileAgent -

=head1 SYNOPSIS

  use Angelos::Middleware::MobileAgent;

=head1 DESCRIPTION

Angelos::Middleware::MobileAgent is

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package HTTP::Request::Dispatcher;
use Mouse;
use HTTP::Router;
use HTTP::Request::Dispatcher::Dispatch::Simple;

our $VERSION = '0.01';

has 'router' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
);

no Mouse;

sub dispatch_class {
    'Request::Dispatcher::Dispatch::Simple';
}

sub dispatch {
    my ( $self, $request ) = @_;
    my $match = $self->router->match( $request->path,
        { method => $request->method } );
    my $dispatch = $self->dispatch_class->new( match => $match );
    return $dispatch;
}

sub set_routeset {
    my ( $self, $routeset ) = @_;
    $self->router->routeset($routeset);
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

HTTP::Request::Dispatcher - Request dispatcher like Rails

=head1 SYNOPSIS

  use HTTP::Request::Dispatcher;

=head1 DESCRIPTION

HTTP::Request::Dispatcher is the request dispatcher like Rails

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

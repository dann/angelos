package Angelos::Dispatcher;
use Angelos::Class;
use Angelos::Dispatcher::Dispatch;
use HTTP::Router;

has 'router' => (
    is      => 'ro',
    default => sub {
        HTTP::Router->new;
    },
);

sub dispatch_class {
    'Angelos::Dispatcher::Dispatch';
}

sub dispatch {
    my ( $self, $request ) = @_;
    my $match = $self->router->match( $request );
    my $dispatch = $self->dispatch_class->new( match => $match );
    return $dispatch;
}

sub set_routeset {
    my ( $self, $routeset ) = @_;
    $self->router->routeset($routeset);
}

__END_OF_CLASS__

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

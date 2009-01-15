package Angelos::Context;
use Mouse;
use Carp ();

with 'Angelos::Class::Pluggable';

has 'app' => (
    is       => 'rw',
    isa      => 'Angelos::Engine',
    required => 1,
    handles  => [qw(controller)],
);

has 'request' => (
    is       => 'rw',
    required => 1
);

has 'response' => (
    is       => 'rw',
    required => 1
);

has 'stash' => (
    is      => 'rw',
    default => sub {
        +{};
    }
);

has '_match' => ( is => 'rw', );

# FIXME
# need to consider later
# this attribute should be added by plugin
# should I use Sub::Install or something like that?
has 'session' => (
    is  => 'rw',
    isa => 'HTTP::Session',
);

no Mouse;

sub req {
    shift->request;
}

sub res {
    shift->response;
}

sub view {
    my ( $self, $view ) = @_;
    my $v = $self->app->view($view);
    Carp::croak "view $view doesn't exist" unless $v;
    $v->context($self);
    $v;
}

sub action {
    my $self =shift;
    $self->_match->params->{action}
}

__PACKAGE__->meta->make_immutable;

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

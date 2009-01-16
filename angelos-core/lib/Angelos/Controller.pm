package Angelos::Controller;
use Mouse;
use Carp ();
use Angelos::Exceptions;

with( 'Angelos::Component', );

has _plugin_app_ns => ( +default => sub { ['Angelos::Controller'] }, );

has 'before_filters' => (
    is       => 'rw',
    required => 1,
    isa      => 'ArrayRef',
    default  => sub {
        [];
    }
);

has 'after_filters' => (
    is       => 'rw',
    required => 1,
    isa      => 'ArrayRef',
    default  => sub {
        [];
    }
);

no Mouse;

sub SETUP {}

sub _call_filters {
    my ( $self, $filters, $context, $action, $params ) = @_;
    foreach my $filter ( @{$filters} ) {
        my $method = $filter->{name};
        unless ( exists $filter->{exclude}
            && $action eq $filter->{exclude} )
        {
            Carp::croak "$method doesn't exist"
                unless __PACKAGE__->meta->has_method($method);
            $self->$method->( $context, $action, $params );
        }
    }
}

sub add_before_filter {
    my ( $self, $filter ) = @_;
    Angelos::Exception::InvalidArgumentError->throw(message => "name key is required")
        unless $filter->{name};
    push @{ $self->before_filters }, $filter;
}

sub add_after_filter {
    my ( $self, $filter ) = @_;
    Angelos::Exception::InvalidArgumentError->throw(message => "name key is required")
        unless $filter->{name};
    push @{ $self->after_filters }, $filter;
}

sub _do_action {
    my ( $self, $context, $action, $params ) = @_;

    return if $context->finished; # already redirected

    $self->_call_filters( $self->before_filters, $context, $action, $params );
    $self->ACTION($context, $action, $params);
    $self->_call_filters( $self->after_filters, $context, $action, $params );
}

sub ACTION {
    my ($self, $context, $action, $params) = @_; 
    $self->$action( $context, $params );
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

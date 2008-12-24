package Angelos::Controller;
use Mouse;
use Carp ();

with( 'Angelos::Component', );

has 'before_filters' => (
    is         => 'rw',
    required   => 1,
    isa        => 'ArrayRef',
    default    => sub {
        [];
    }
);

has 'after_filters' => (
    is         => 'rw',
    required   => 1,
    isa        => 'ArrayRef',
    default    => sub {
        [];
    }
);

no Mouse;

sub _call_filters {
    my ( $self, $filters, $context, $action, $params ) = @_;
    foreach my $filter ( @{$filters} ) {
        my $method = $filter->{name};
        unless ( exists $filter->{except}
            && $action eq $filter->{except} )
        {
            Carp::croak "$method doesn't exist"
                unless __PACKAGE__->meta->has_method($method);
            $self->$method->( $context, $action, $params );
        }
    }
}

sub add_before_filter {
    my ( $self, $filter ) = @_;
    Carp::croak "name key is required" unless $filter->{name};
    push @{ $self->before_filters }, $filter;
}

sub add_after_filter {
    my ( $self, $filter ) = @_;
    Carp::croak "name key is required" unless $filter->{name};
    push @{ $self->after_filters }, $filter;
}

sub _do_action {
    my ( $self, $context, $action, $params ) = @_;
    $self->_call_filters( $self->before_filters,
        $context, $action, $params );
    $self->$action( $context, $params );
    $self->_call_filters( $self->after_filters,
        $context, $action, $params );
}

__PACKAGE__->meta->make_immutable;

1;

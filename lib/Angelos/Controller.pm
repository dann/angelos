package Angelos::Controller;
use Mouse;
use Carp ();

with( 'Angelos::Component', );

has 'before_filters' => (
    is         => 'rw',
    required   => 1,
    isa        => 'ArrayRef',
    auto_deref => 1,
    default    => sub {
        [];
    }
);

has 'after_filters' => (
    is         => 'rw',
    required   => 1,
    isa        => 'ArrayRef',
    auto_deref => 1,
    default    => sub {
        [];
    }
);

no Mouse;

sub _execute_before_filters {
    my ( $self, $context, $action, $params ) = @_;
    foreach my $before_filter ( $self->before_filters ) {
        my $method = $before_filter->{name};
        unless ( exists $before_filter->{except}
            && $action eq $before_filter->{except} )
        {
            Carp::croak "$method doesn't exist"
                unless __PACKAGE__->meta->has_method($method);
            $self->$method( $context, $action, $params );
        }
    }
}

sub _execute_after_filters {
    my ( $self, $context, $action, $params ) = @_;
    foreach my $after_filter ( $self->after_filters ) {
        my $method = $after_filter->{name};
        unless ( exists $after_filter->{except}
            && $action eq $after_filter->{except} )
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
    $self->_execute_before_filters( $context, $action, $params );
    $self->$action( $context, $params );
    $self->_execute_after_filters( $context, $action, $params );
}

__PACKAGE__->meta->make_immutable;

1;

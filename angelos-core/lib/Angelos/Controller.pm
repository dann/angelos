package Angelos::Controller;
use Angelos::Class;
use Carp ();
use Angelos::Exceptions qw(rethrow_exception);
use Exception::Class;
use Angelos::Utils;
use String::CamelCase;

with  'Angelos::Component';
with  'Angelos::Controller::Mixin::Responder';

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

has 'context' => (
    is      => 'rw',
    handles => [
        qw(
            req
            res
            forward
            detach
            forward_with_filters
            detach_with_filters
            model
            view
            controller
            session 
            )
    ],
);

sub SETUP { }

sub _call_filters {
    my ( $self, $filters, $action, $params ) = @_;
    foreach my $filter ( @{$filters} ) {
        my $method = $filter->{name};
        unless ( exists $filter->{exclude}
            && $action eq $filter->{exclude} )
        {
            Carp::croak "$method doesn't exist"
                unless __PACKAGE__->meta->has_method($method);
            $self->$method->( $self->context, $action, $params );
        }
    }
}

sub add_before_filter {
    my ( $self, $filter ) = @_;
    Angelos::Exception::InvalidArgumentError->throw(
        message => "name key is required" )
        unless $filter->{name};
    push @{ $self->before_filters }, $filter;
}

sub add_after_filter {
    my ( $self, $filter ) = @_;
    Angelos::Exception::InvalidArgumentError->throw(
        message => "name key is required" )
        unless $filter->{name};
    push @{ $self->after_filters }, $filter;
}

sub _dispatch_action {
    my ( $self, $action, $params ) = @_;

    return if $self->context->finished;    # already redirected

    $self->_call_filters( $self->before_filters, $action, $params );
    eval { $self->ACTION( $self->context, $action, $params ); };

    my $e;
    if ( $e = Exception::Class->caught('Angelos::Exception::Detach') ) {
        $self->log->info("Detached");
    }
    elsif ( $e = Exception::Class->caught() ) {
        $self->log->error($e);
        rethrow_exception($e);
    }

    $self->_call_filters( $self->after_filters, $action, $params );
}

sub ACTION {
    my ( $self, $context, $action, $params ) = @_;
    $self->$action($params);
}

__END_OF_CLASS__

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>
vkgtaro

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

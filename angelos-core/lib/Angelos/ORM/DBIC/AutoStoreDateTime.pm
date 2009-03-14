package Angelos::ORM::DBIC::AutoStoreDateTime;
use strict;
use warnings;
use base 'DBIx::Class';

# steal from MoFedge::Data::DBIC::AutoStoreDataTime
sub insert {
    my $self = shift;

    $self->store_column( 'created_on', $self->datetime->now )
        if $self->result_source->has_column('created_on');

    $self->next::method(@_);
}

sub update {
    my $self = shift;

    $self->updated_on( $self->datetime->now )
        if $self->result_source->has_column('updated_on');

    $self->next::method(@_);
}

1;

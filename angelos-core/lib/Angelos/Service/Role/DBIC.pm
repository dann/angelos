package Angelos::Service::Role::DBIC;
use Angelos::Role;
use List::MoreUtils;

has 'resultset_moniker' => (
    is       => 'rw',
    required => 1,
    builder  => 'build_resultset_moniker'
);

has 'schema' => (
    is       => 'rw',
    required => 1
);

has 'cache' => (
    is       => 'rw',
    required => 1
);

has 'primary_key' => (
    is       => 'rw',
    required => 1,
    default  => 'id',
);

sub find {
    my ( $self, $id ) = @_;

    my $cache_key = $self->cache_key($id);
    my $obj       = $self->get_from_cache($cache_key);
    if ( !$obj ) {
        $obj = $self->_resultset->find($id);
        if ($obj) {
            $self->cache->set( $cache_key, $obj );
        }
    }
    return $obj;
}

sub get_from_cache {
    my ( $self, $cache_key ) = @_;
    my $obj = $self->cache->get($cache_key);
    $obj;
}

sub get_multi_from_cache {
    my ( $self, @keys ) = @_;
    my $objs = $self->cache->get_multi_hashref( \@keys );
    $objs;
}

sub find_multi {
    my ( $self, @ids ) = @_;

    my %id2key = map { $_ => $self->cache_key($_) } grep {defined} @ids;
    my $got = $self->get_multi_from_cache( values %id2key );

    ## If we got back all of the objects from the cache, return immediately.
    if ( List::MoreUtils::all { defined $_ } values %$got ) {
        my @objs = values %{$got};
        return \@objs;
    }

    ## Otherwise, look through the list of IDs to see what we're missing,
    ## and fall back to the backend to look up those objects.
    my ( $i, @got, @need, %need2got ) = (0);
    for my $id (@ids) {
        if ( defined $id && ( my $obj = $got->{ $id2key{$id} } ) ) {
            push @got, $obj;
        }
        else {
            push @got,  undef;
            push @need, $id;
            $need2got{$#need} = $i;
        }
        $i++;
    }

    if (@need) {
        for my $id (@need) {
            my $obj = $self->find($id);
            $got[ $need2got{ $i++ } ] = $obj;
        }
    }

    \@got;
}

sub cache_key {
    my ( $self, $id ) = @_;
    my $cache_key = join '-', ( __PACKAGE__, ref $self, $id );
    return $cache_key;
}

sub find_or_create {
    my ( $self, $args ) = @_;
    $self->_resultset->find_or_create($args);
}

sub update_or_create {
    my ( $self, $args ) = @_;
    $self->_resultset->update_or_create($args);
}

sub new {
    my ( $self, $args ) = @_;
    $self->_resultset->new($args);
}

sub search {
    my ( $self, $args ) = @_;
    $self->_resultset->search($args);
}

sub search_rs {
    my ( $self, $args ) = @_;
    $self->_resultset->search_rs($args);
}

sub search_literal {
    my ( $self, $args ) = @_;
    $self->_resultset->search_literal($args);
}

sub first {
    my ( $self, $args ) = @_;
    $self->_resultset->first($args);
}

sub update {
    my ( $self, $args ) = @_;

    my $pk  = $self->primary_key();
    my $rs  = $self->resultset();
    my $key = delete $args->{$pk};
    my $row = $self->find($key);
    if ($row) {
        while ( my ( $field, $value ) = each %$args ) {
            $row->$field($value);
        }
        $row->update;
    }
    $self->_resultset->update($args);
}

sub update_all {
    my ( $self, $args ) = @_;
    $self->_resultset->update_all($args);
}

sub delete {
    my ( $self, $id ) = @_;
    my $obj = $self->_resultset->find($id);
    if ($obj) {
        $obj->delete;
    }

    my $cache_key = $self->cache_key($id);
    $self->cache->delete($cache_key);

}

sub delete_all {
    my ( $self, $args ) = @_;
    $self->_resultset->delete_all($args);
}

sub all {
    my ( $self, $args ) = @_;
    $self->_resultset->all($args);
}

sub pager {
    my $self = shift;
    $self->_resultset->pager(@_);
}

sub page {
    my ( $self, $args ) = @_;
    $self->_resultset->page($args);
}

sub reset {
    my ( $self, $args ) = @_;
    $self->_resultset->reset($args);
}

sub count {
    my ( $self, $args ) = @_;
    $self->_resultset->count($args);
}

sub count_literal {
    my ( $self, $args ) = @_;
    $self->_resultset->count_literal(@_);
}

sub _resultset {
    my $self = shift;
    my $rs = $self->schema->resultset( $self->resultset_moniker );
    $rs;
}

sub build_resultset_moniker {
    my ( $self, $args ) = @_;
    ( split( /::/, ref $self ) )[-1];
}

1;

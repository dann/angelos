package Angelos::Service::Role::DBIC;
use Angelos::Role;

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

sub find {
    my ( $self, $id ) = @_;
    my $cache_key = $self->_create_cache_key($id);
    my $obj       = $self->cache->get($cache_key);
    if ( !$obj ) {
        warn 'aa';
        $obj = $self->_resultset->find($id);
        warn 'bb';
        if ($obj) {
            warn 'cc';
            warn $cache_key;
            $self->cache->set( $cache_key, $obj );
        }
    }
    return $obj;
}

sub get_multi {
    my ( $self, @ids ) = @_;
    my $rs   = $self->_resultset();
    my $objs = $self->cache->get_multi_arrayref(
        map { [ $self->_create_cache_key($_) ] } @ids );
    my @ret = $objs ? @$objs : ();
    return wantarray ? @ret : \@ret;
}

sub _create_cache_key {
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

    my $cache_key = $self->_create_cache_key($id);
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
    $self->schema->resultset( $self->resultset_moniker );
}

sub build_resultset_moniker {
    my ( $self, $args ) = @_;
    ( split( /::/, ref $self ) )[-1];
}

1;

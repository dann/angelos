package Angelos::Model::DBIC;
use Angelos::Class;
use Data::Dumper;
extends 'Angelos::Model';
with 'Angelos::Class::ComponetnLoadable';

use Carp qw(croak);

has 'schema_class' => ( is => 'rw', );

has 'storage_type' => ( is => 'rw', );

has 'connect_info' => ( is => 'rw', );

has 'composed_schema' => ( is => 'rw', );

sub BUILD {
    my $self       = shift;
    my $class      = ref($self);
    my $model_name = $class;
    $model_name =~ s/^[\w:]+::(?:Model|M):://;

    croak "schema_class must be defined for this model"
        unless $self->schema_class;

    my $schema_class = $self->schema_class;

    $schema_class->require
        or croak "Cannot load schema class '$schema_class': $@";

    if ( !$self->connect_info ) {
        if ( $schema_class->storage && $schema_class->storage->connect_info )
        {
            $self->connect_info( $schema_class->storage->connect_info );
        }
        else {
            croak "Either ->config->{connect_info} must be defined for $class"
                . " or $schema_class must have connect info defined on it"
                . "Here's what we got:\n"
                . Dumper($self);
        }
    }

    $self->composed_schema( $schema_class->compose_namespace($class) );
    $self->schema( $self->composed_schema->clone );

    $self->schema->storage_type( $self->storage_type )
        if $self->storage_type;

    $self->schema->connection(
        ref $self->connect_info eq 'ARRAY'
        ? @{ $self->connect_info }
        : $self->connect_info
    );

    no strict 'refs';
    foreach my $moniker ( $self->schema->sources ) {
        my $classname = "${class}::$moniker";
        $self->set_component($model_name,$self->schema->resultset($moniker));
    }

    return $self;
}

sub clone { shift->composed_schema->clone(@_); }

sub connect { shift->composed_schema->connect(@_); }

sub storage { shift->schema->storage(@_); }

__END_OF_CLASS__

__END__

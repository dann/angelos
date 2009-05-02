package Angelos::ORM::DBIC::Schema;
use strict;
use warnings;
use base qw/DBIx::Class::Schema/;
use Switch;

__PACKAGE__->load_components(qw/
    +Angelos::ORM::DBIC::AutoInflateDateTime
    +Angelos::ORM::DBIC::AutoStoreDateTime
    AsFdat
    UTF8Columns
    PK::Auto
    Core
/);


__PACKAGE__->mk_classdata('master_schema');
__PACKAGE__->mk_classdata('slave_schema');

sub register_column {
    my ($class, $column) = @_;

    $class->next::method($column);

    switch ($column) {
        case /^created_on$/ { $class->datetime_column($column)     }
        case /^updated_on$/ { $class->datetime_column($column)     }
        case /_on$/         { $class->date_column($column)         }
        case /_at$/         { $class->datetime_column($column)     }
    }
}

sub master {
    my $class = shift;
    my $connect_info
        = $class->config->database->{'master'}->{'connect_info'};
    $class->master_schema($class->connect( @{$connect_info} )) unless $class->master_schema;
    $class->master_schema;
}

sub slave {
    my $class = shift;
    return unless $class->config->database->{slave}; 
    my $connect_info
        = $class->config->database->{'slave'}->{'connect_info'};
    $class->slave_schema($class->connect( @{$connect_info} )) unless $class->slave_schema;
    $class->slave_schema;
}

sub config {
    die 'sub class must implement config method';
}

1;

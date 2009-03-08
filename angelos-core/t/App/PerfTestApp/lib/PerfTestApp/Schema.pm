package PerfTestApp::Schema;
use Mouse;
use PerfTestApp::Config;
extends qw(DBIx::Class::Schema);

sub master {
    my $class        = shift;
    my $connect_info = $class->config->{'Model::DBIC'}{'connect_info'};
    my $schema       = $class->connect( @{$connect_info} );
    return $schema;
}

sub slave {
    my $class = shift;
    return unless $class->config->{'Model::DBIC::Slave'};
    my $connect_info = $class->config->{'Model::DBIC::Slave'}{'connect_info'};
    my $schema       = $class->connect( @{$connect_info} );
    return $schema;
}

sub config {
    PerfTestApp::Config->instance;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

package TestApp::Schema;
use Mouse;
use TestApp::Config;
extends qw(DBIx::Class::Schema);
__PACKAGE__->load_classes();

our $master_schema;
our $slave_schema;

sub master {
    my $class = shift;
    my $connect_info
        = $class->config->database->{'master'}->{'connect_info'};
    $master_schema ||= $class->connect( @{$connect_info} );
    $master_schema;
}

sub slave {
    my $class = shift;
    return unless $class->config->{'database'};
    return unless $class->config->{'database'}->{'slave'};
    my $connect_info
        = $class->config->{'database'}->{'slave'}->{'connect_info'};
    $slave_schema ||= $class->connect( @{$connect_info} );
    $slave_schema;
}

sub config {
    TestApp::Config->instance;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

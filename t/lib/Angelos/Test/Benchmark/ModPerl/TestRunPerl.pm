package Angelos::Test::Benchmark::ModPerl::TestRunPerl;
use strict;
use warnings;
use base qw(Apache::TestRunPerl);

sub new_test_config {
    my $self = shift;
  
    my $maxclients = $ENV{APACHE_MAXCLIENTS} || 2;
    $self->{conf_opts}->{maxclients} = $maxclients;
    my $minclients = $ENV{APACHE_MINCLIENTS} || 1;
    $self->{conf_opts}->{minclients} = $minclients;

    print STDERR <<EOM;

Generating config with the following custom settings
    MaxClients: $maxclients
    MinClients: $minclients

EOM

    return $self->SUPER::new_test_config;
}

1;

__END__



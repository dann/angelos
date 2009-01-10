package Angelos::Test::Benchmark::ModPerl;
use strict;
use warnings;
use base qw(Exporter);
use Apache::TestConfig;
use Apache::TestUtil qw(t_debug);
use File::Spec;
use IPC::Open3;
use Test::More;
use URI;
use Path::Class;
our $VERSION = '0.00001';

# This code is stolen from App-Benchmark-WAF

our @EXPORT = qw(benchmark_diag);
our $AB;
BEGIN {
    require File::Spec->catfile('t', 'conf', 'apache_test_config.pm');
    my $config = apache_test_config->new();
    $AB ||= $ENV{APACHE_BENCH};
    $AB ||= File::Spec->catfile($config->{vars}->{bindir}, "ab");

    if (! -x $AB) {
        plan skip_all => "set TEST_MODPERL to enable this test" unless $ENV{TEST_MODPERL};
        plan skip_all => "could not find a working $AB. You can set ab path with  APACHE_BENCH env";
    } else {
        plan skip_all => "set TEST_MODPERL to enable this test" unless $ENV{TEST_MODPERL};
        plan('no_plan');
    }
}

sub benchmark_diag {
    my %args   = @_;

    my $mode = $args{mode};
    my $type = $args{type};

    my $config = apache_test_config->new();
    my $uri = URI->new();
    $uri->scheme('http');
    $uri->host( $config->our_remote_addr() );
    $uri->port( $config->port );
    $uri->path( $args{path} || join('/', $mode, $type, 'index.cgi' ) );

    my $post = $args{post} 
        ? "-p $args{post} -T \"application/x-www-form-urlencoded\"" : ''; 
    my @cmd = ($AB,
        "-c", $args{concurrency} || $ENV{AB_CONCURRENCY} || 100,
        "-n", $args{requests} || $ENV{AB_REQUESTS} || 1000, $post, $uri);
   
    t_debug("running $type in $mode ($uri)");
    t_debug("command: @cmd");

    # capture output...
    {
        my ($stdout, $stdin, $stderr);
        open3( $stdin, $stdout, $stderr, "@cmd" );
        while (<$stdout>) {
            t_debug($_);
            next unless /Requests per second:\s*(.*)$/;
            diag("[$type ($mode)]: $1");
        }
    }
    ok(1);
}

1;

__END__



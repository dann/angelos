#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use Test::TCP;
use PerfTestApp;
use LWP::UserAgent;
use Benchmark qw/countit timethese timeit timestr/;
use IO::Scalar;

my $module = shift || 'ServerSimple';
my $port   = shift || empty_port();
my $loop   = shift || 100;

test_tcp(
    client => sub {

        my $port = shift;
        tie *STDOUT, 'IO::Scalar', \my $out;
        my $t = countit 2 => sub {
            my $ua = LWP::UserAgent->new;
            $ua->get("http://localhost:$port/");
        };
        untie *STDOUT;
        print timestr($t), "\n";

    },
    server => sub {
        my $port   = shift;
        my $engine = PerfTestApp->new(
            server => $module,
            port   => $port,
        );
        $engine->run;
    },
);


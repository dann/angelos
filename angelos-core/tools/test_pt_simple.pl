#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use lib glob 't/App/*/lib';
use Test::TCP;
use PerfTestApp;
use HTTP::Engine;
use LWP::UserAgent;
use Benchmark qw/countit timethese timeit timestr/;
use IO::Scalar;

my $module = shift || 'ServerSimple';
my $port   = shift || empty_port();
my $loop   = shift || 1000;

test_tcp(
    client => sub {

        my $port = shift;
        tie *STDOUT, 'IO::Scalar', \my $out;

        my $t = countit 3 => sub {
            my $ua = LWP::UserAgent->new;
            $ua->get("http://localhost:$port/root/index");
        };
        untie *STDOUT;
        my $count = $t->iters;
        print "$count loops of get response from angelos took:", timestr($t), "\n";

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


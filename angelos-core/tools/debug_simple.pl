#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib', 't/lib', 't/TestApp/lib';
use Test::TCP;
use TestApp;
use HTTP::Engine;
use LWP::UserAgent;
use Carp::Always;

my $module = shift || 'ServerSimple';
my $port = shift || empty_port();
my $loop = shift || 100;

test_tcp(
    client => sub {
        my $port = shift;
        my $ua   = LWP::UserAgent->new;
        $ua->get("http://localhost:$port/");

        $ua->get("http://localhost:$port/forward");

        $ua->get("http://localhost:$port/detach");
    },
    server => sub {
        my $port = shift;
        my $engine = TestApp->new(
            server => $module,
            port   => $port,
        );
        $engine->setup;
        $engine->run;
    },
);


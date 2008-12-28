#!/usr/bin/env perl
use strict;
use warnings;
use lib 't/lib';
use Test::TCP;
use TestApp::Web;
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
    },
    server => sub {
        my $port = shift;
        my $engine = TestApp::Web->new(
            server => $module,
            port   => $port,
        );
        $engine->setup;
        $engine->run;
    },
);


#!/usr/bin/env perl
use strict;
use warnings;
use FindBin::libs;
use lib glob 't/App/*/lib';
use Test::More tests => 1;
use Test::TCP;
use TestApp;
use HTTP::Engine;
use LWP::UserAgent;

my $module = shift || 'ServerSimple';
my $port = shift || empty_port();
my $loop = shift || 100;

test_tcp(
    client => sub {
        my $port = shift;
        my $ua   = LWP::UserAgent->new;
        my $res = $ua->get("http://localhost:$port/");
        ok $res->is_success , 'get success';
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


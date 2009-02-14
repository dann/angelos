#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib', 't/lib'; 
use lib glob 't/App/*/lib';
use Test::TCP;
use TestApp;
use LWP::UserAgent;

my $module = shift || 'ServerSimple';
my $port = shift || empty_port();
my $loop = shift || 100;

test_tcp(
    client => sub {
        my $port = shift;
        my $ua   = LWP::UserAgent->new;
        $ua->get("http://localhost:$port/root/index");
        $ua->get("http://localhost:$port/root/tt");
        $ua->get("http://localhost:$port/root/forward_test");
        $ua->get("http://localhost:$port/root/detach_test");
    },
    server => sub {
        my $port = shift;
        my $engine = TestApp->new(
            server => $module,
            port   => $port,
        );
        $engine->run;
    },
);


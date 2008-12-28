#!/usr/bin/env perl
use strict;
use warnings;
use lib 't/lib';
use Test::TCP;
use TestApp::Web;
use HTTP::Engine;
use LWP::UserAgent;
#use Carp::Always;

my $module = shift || 'ServerSimple';
my $port = shift || empty_port();
my $loop = shift || 100;

test_tcp(
    client => sub {
        my $port = shift;
        my $ua   = LWP::UserAgent->new;
        for ( 0 .. $loop ) {
            $ua->get("http://localhost:$port/");
        }
    },
    server => sub {
        my $port = shift;
        if ( !$ENV{NO_NYTPROF} ) {
            require Devel::NYTProf;
            $ENV{NYTPROF} = 'start=no';
            Devel::NYTProf->import;
            DB::enable_profile();
            $SIG{TERM} = sub { DB::_finish(); exit; };
        }
        my $engine = TestApp::Web->new(
            server => $module,
            port   => $port,
        );
        $engine->setup;
        $engine->run;

    },
);


#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib', 't/lib';
use lib glob 't/App/*/lib';
use Test::TCP;
use TestApp;
use HTTP::Engine;
use LWP::UserAgent;
use Getopt::Long;
use Pod::Usage;

my %argv = (
    module => 'ServerSimple',
    port  => empty_port(),
    loop => 1,
);

GetOptions(
    \%argv,
    "module=s",
    "port=i",
    "loop=i",
    "help",
) or $argv{help}++;

pod2usage(2) if $argv{help};

my $module = $argv{module};;
my $port = $argv{port};
my $loop = $argv{loop};

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
        my $engine = TestApp->new(
            server => $module,
            port   => $port,
        );
        $engine->setup;
        $engine->run;

    },
);


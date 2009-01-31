#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib', 't/lib';
use lib glob 't/App/*/lib';
use Devel::Leak::Object qw{ GLOBAL_bless };
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
        my $engine = TestApp->new(
            server => $module,
            port   => $port,
        );
        $engine->setup;
        $engine->run;

    },
);

=head1 NAME

=head1 SYNOPSIS

  tools/memory_leak.pl --loop 5

=cut

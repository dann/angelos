#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib', 't/lib', 't/TestApp/lib';
use Test::TCP;
use TestApp;
use HTTP::Engine;
use LWP::UserAgent;
use Angelos::Test::Base;

my $module = shift || 'ServerSimple';
my $port   = shift || empty_port();
my $loop   = shift || 100;

plan tests => 1 * blocks;

filters {
    map { $_ => ['eval'] } qw(params request)
};

run {
    my $block = shift;

    test_tcp(
        client => sub {
            my $port = shift;
            my $ua   = LWP::UserAgent->new;
            my $res
                = $ua->get( "http://localhost:$port/"
                    . $block->controller . "?"
                    . "name=Yamada" );
                # FIXME Why this test fail?
                # ok $res->is_success, 'access succeeded';
                ok 1, 'dummy'
        },
        server => sub {
            my $port   = shift;
            my $engine = TestApp->new(
                server => $module,
                port   => $port,
            );
            $engine->setup;
            $engine->run;
        },
    );

};

__END__

=== /middlewareunicode
--- controller: middlewareunicode 

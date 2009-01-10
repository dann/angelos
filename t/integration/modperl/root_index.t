use strict;
use warnings;
use Apache::Test qw(ok :withtestmore);
use Apache::TestRequest qw(GET POST);
use Test::More;

plan skip_all => "set TEST_MODPERL to enable this test" unless $ENV{TEST_MODPERL};
plan tests => 1;

my $res = GET '/';
ok $res->code == 200, "Request is ok";
#is $res->content, 'fuga';

use strict;
use warnings;
use Apache::Test qw(ok :withtestmore);
use Apache::TestRequest qw(GET POST);
use Test::Most;

plan skip_all => "set TEST_MODPERL to enable this test" unless $ENV{TEST_MODPERL};
plan tests => 1;

GET_ROOT: {
    my $res = GET '/';
    is $res->code, 200, "Request is ok";
}

#SHOW_WITH_TT: {
#    my $res = GET '/tt';
#    is $res->code, 200, "Request is ok";
#}


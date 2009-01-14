use strict;
use lib 't/lib','t/TestApp/lib';
use Angelos::Test::Benchmark::ModPerl;

benchmark_diag(
    type => 'http-engine',
    mode => 'modperl',
    path => '/modperl/http-engine'
);

1;

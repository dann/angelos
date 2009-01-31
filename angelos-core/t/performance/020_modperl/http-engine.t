use strict;
use FindBin::libs;
use lib glob 't/App/*/lib';
use Angelos::Test::Benchmark::ModPerl;

benchmark_diag(
    type => 'http-engine',
    mode => 'modperl',
    path => '/modperl/http-engine'
);

1;

use strict;
use lib 't/lib';
use Angelos::Test::Benchmark::ModPerl;

benchmark_diag(
    type => 'angelos',
    mode => 'modperl',
    path => '/'
);

1;

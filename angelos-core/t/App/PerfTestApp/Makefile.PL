use inc::Module::Install;
name 'PerfTestApp';
all_from 'lib/PerfTestApp.pm';

tests 't/*.t t/unit/*.t t/integration/*.t';
#author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

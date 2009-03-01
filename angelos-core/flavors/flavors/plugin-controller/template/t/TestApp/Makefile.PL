use inc::Module::Install;
name 'TestApp';
all_from 'lib/TestApp.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

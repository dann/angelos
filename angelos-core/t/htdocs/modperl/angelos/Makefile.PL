use inc::Module::Install;
name 'TestModPerl-Angelos';
all_from 'lib/TestModPerl/Angelos.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

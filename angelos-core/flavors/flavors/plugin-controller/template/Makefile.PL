use inc::Module::Install;
name '[% dist %]';
all_from 'lib/[% module_path %].pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

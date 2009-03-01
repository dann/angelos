use inc::Module::Install;
name '[% dist %]';
all_from 'lib/[% module_path %].pm';

tests 't/*.t t/unit/*.t t/integration/*.t';
#author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

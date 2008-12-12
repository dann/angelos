use inc::Module::Install;
name 'Angelos';
all_from 'lib/Angelos.pm';

requires $_ for (qw/ /);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

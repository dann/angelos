use inc::Module::Install;
name 'Angelos-Handler';
all_from 'lib/Angelos/Handler.pm';

requires 'Angelos::Core';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

use inc::Module::Install;
name 'Angelos-JobQueue';
all_from 'lib/Angelos/JobQueue.pm';

requires 'Angelos';
requires 'Gearman::Client';
requires 'Gearman::Worker';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

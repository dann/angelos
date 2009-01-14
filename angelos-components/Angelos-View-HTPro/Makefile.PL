use inc::Module::Install;
name 'Angelos-View-HTPro';
all_from 'lib/Angelos/View/HTPro.pm';

requires 'HTML::Template::Pro';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

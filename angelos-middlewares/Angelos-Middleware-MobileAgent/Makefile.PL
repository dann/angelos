use inc::Module::Install;
name 'Angelos-Middleware-MobileAgent';
all_from 'lib/Angelos/Middleware/MobileAgent.pm';

requires(
    'Angelos'           => 0,
    'HTTP::MobileAgent' => 0,
);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

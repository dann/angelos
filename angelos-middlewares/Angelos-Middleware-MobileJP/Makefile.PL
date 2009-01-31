use inc::Module::Install;
name 'Angelos-Middleware-MobileJP';
all_from 'lib/Angelos/Middleware/MobileJP.pm';

requires(
    'Angelos'                           =>  0,
    'HTTP::MobileAgent'                  => 0,
    'Encode::JP::Mobile'                 => 0,
    'HTTP::MobileAgent::Plugin::Charset' => 0,
    'Data::Visitor::Encode'              => 0,
);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

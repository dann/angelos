use inc::Module::Install;
name 'Angelos';
all_from 'lib/Angelos.pm';

requires 'Mouse';
requires 'HTTP::Router';
requires 'HTTP::Engine';
requires 'Module::Pluggable::Object';
requires 'Log::Dispatch::Config';
requires 'Log::Dispatch::Configurator';
requires 'Log::Dispatch::Configurator::YAML';
requires 'MIME::Types';
requires 'Path::Class';
requires 'Text::SimpleTable';
requires 'YAML';
requires 'Devel::InnerPackage';
requires 'Class::Inspector';
requires 'Module::Setup';
requires 'Kwalify';

build_requires 'Test::More';

install_script 'bin/angelos-gen';

author_tests('xt');
use_test_base;
auto_include;
WriteAll;

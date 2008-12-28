use inc::Module::Install;
name 'Angelos';
all_from 'lib/Angelos.pm';

requires 'Mouse';
requires 'HTTP::Engine';
requires 'HTTP::Router';
requires 'HTTP::Session';
requires 'Module::Pluggable::Object';
requires 'UNIVERSAL::require';
requires 'Log::Dispatch::Config';
requires 'Log::Dispatch::Configurator';
requires 'Log::Dispatch::Configurator::YAML';
requires 'Path::Class';
requires 'Text::SimpleTable';
requires 'YAML';
requires 'Devel::InnerPackage';
requires 'Module::Setup';
requires 'Kwalify';
requires 'Locale::Maketext::Simple';
requires 'Locale::Maketext::Extract';
requires 'Sub::Exporter';
requires 'Devel::EvalContext';
requires 'App::CLI';
requires 'Pod::Simple::Text';
requires 'FindBin::libs';
requires 'String::CamelCase';
requires 'MIME::Types';
requires 'Template';
requires 'Error';
requires 'Error::Simple';
requires 'File::Find::Rule';
requires 'Devel::MemUsed';
requires 'JSON::XS';

build_requires 'Test::More';

install_script 'bin/angelos';

author_tests('xt');
use_test_base;
auto_include;
WriteAll;

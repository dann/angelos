use inc::Module::Install;
name 'Angelos';
all_from 'lib/Angelos.pm';

# Core
requires 'Mouse' => '0.14';
requires 'HTTP::Engine';
requires 'HTTP::Router';
requires 'HTTP::Session';
requires 'Module::Pluggable::Object';
requires 'UNIVERSAL::require';
requires 'Log::Dispatch::Config';
requires 'Log::Dispatch::Configurator';
requires 'Log::Dispatch::Configurator::YAML';
requires 'Log::Dispatch::Colorful';
requires 'String::CamelCase';
requires 'Path::Class';
requires 'Locale::Maketext::Simple';
requires 'Locale::Maketext::Extract';

requires 'Kwalify';
requires 'YAML';
requires 'Devel::InnerPackage';
requires 'Module::Setup';
requires 'App::Cmd';
requires 'Pod::Simple::Text';
requires 'FindBin::libs';

requires 'Exception::Class';
requires 'File::Find::Rule';
requires 'Template';

# debug
requires 'Devel::MemUsed';
requires 'Text::SimpleTable';

# should not be in core
# will separate these modules from core
requires 'Term::ReadLine';
requires 'Devel::EvalContext';
requires 'JSON::XS';
requires 'MIME::Types';

# plugins
# will separete these modules from core
requires 'FormValidator::Simple';

build_requires 'Test::More';

install_script 'bin/angelos';

#author_tests('xt');
use_test_base;
auto_include;
WriteAll;

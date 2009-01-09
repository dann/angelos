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

# components
requires 'Template';

# i18n
requires 'Locale::Maketext::Simple';
requires 'Locale::Maketext::Extract';

# config
requires 'Kwalify';
requires 'YAML';
requires 'Data::Visitor::Callback';

requires 'Devel::InnerPackage';
requires 'Module::Setup';
requires 'App::Cmd';
requires 'Pod::Simple::Text';
requires 'FindBin::libs';

requires 'Exception::Class';
requires 'File::Find::Rule';


requires 'MouseX::Getopt';
requires 'IPC::System::Simple';

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


tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::MockObject';
test_requires 'Test::Most';
test_requires 'Test::Class';

install_script 'bin/angelos';

author_tests('xt');
use_test_base;
auto_include;
WriteAll;

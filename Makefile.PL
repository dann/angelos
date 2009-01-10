use inc::Module::Install;

BEGIN
{
    eval { 
        die "not testing mod_perl" unless $ENV{TEST_MODPERL};
        require mod_perl2;
        require Apache::Test;
    };
    {
        no strict 'refs';
        *HAVE_MP = $@ ? sub { 0 } : sub { 1 };
    }
}

if (HAVE_MP) {
    require Apache::TestMM;
    Apache::TestMM->import(qw(clean test));
}

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
requires 'Devel::InnerPackage';
requires 'Exception::Class';

# components
requires 'Template';

# i18n
requires 'Locale::Maketext::Simple';
requires 'Locale::Maketext::Extract';

# config
requires 'Kwalify';
requires 'YAML';
requires 'Data::Visitor::Callback';

# script
requires 'Pod::Simple::Text';
requires 'MouseX::Getopt';
requires 'IPC::System::Simple';
requires 'App::Cmd';
requires 'Module::Setup';
requires 'FindBin::libs';

# debug
requires 'Devel::MemUsed';
requires 'Text::SimpleTable';
requires 'File::Find::Rule';

# should not be in core
# will separate these modules from core
requires 'Term::ReadLine';
requires 'Devel::EvalContext';
requires 'JSON::XS';
requires 'MIME::Types';

# plugins
# will separete these modules from core
requires 'FormValidator::Simple';


#requires 'Gearman::Client';
#requires 'Gearman::Worker';
#requires 'HTML::Template::Pro';

if (HAVE_MP) {
    require Cwd;
    Apache::TestMM::filter_args();
    Apache::TestMM::generate_script('t/TEST');
    tests('t/integration/modperl/*.t');
} else {
    tests('t/*.t t/unit/*.t t/unit/*/*.t');
    author_tests('xt');
}

test_requires 'Test::More';
test_requires 'Test::Differences';
test_requires 'Test::Deep';
test_requires 'Test::Exception';
test_requires 'Test::MockObject';
test_requires 'Test::Class';
test_requires  'Module::Load::Conditional';

install_script 'bin/angelos';

use_test_base;
auto_include;
WriteAll;

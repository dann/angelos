#use lib 'privinc';
use inc::Module::Install;

BEGIN {
    eval {
        die "not testing mod_perl" unless $ENV{TEST_MODPERL};
        require mod_perl2;
        require Apache::Test;
    };
    {
        no strict 'refs';
        *HAVE_MP = $@ ? sub {0} : sub {1};
    }

}

if (HAVE_MP) {

    #include 'Module/Install/PRIVATE/Angelos.pm';
    require Apache::TestMM;
    Apache::TestMM->import(qw(clean test));
}

name 'Angelos';
all_from 'lib/Angelos.pm';

# Core
requires 'Mouse'                             => '0.14';
requires 'HTTP::Engine'                      => 0;
requires 'HTTP::Router'                      => 0;
requires 'HTTP::Session'                     => 0;
requires 'Module::Pluggable::Object'         => 0;
requires 'UNIVERSAL::require'                => 0;
requires 'Log::Dispatch::Config'             => 0;
requires 'Log::Dispatch::Configurator'       => 0;
requires 'Log::Dispatch::Configurator::YAML' => 0;
requires 'Log::Dispatch::Colorful'           => 0;
requires 'String::CamelCase'                 => 0;
requires 'Path::Class'                       => 0;
requires 'Devel::InnerPackage'               => 0;
requires 'Exception::Class'                  => 0;
requires 'File::Spec'                        => 0;
requires 'IO::Pager'                         => 0;
requires 'Class::Singleton'                  => 0;
requires 'Params::Validate'                  => 0;
requires 'Class::Method::Modifiers::Fast'    => 0;

# components
requires 'Template' => 0;

# i18n
requires 'Locale::Maketext::Simple'  => 0;
requires 'Locale::Maketext::Extract' => 0;

# config
requires 'Kwalify'                 => 0;
requires 'YAML'                    => 0;
requires 'Data::Visitor::Callback' => 0;

# script
requires 'Pod::Simple::Text'   => 0;
requires 'MouseX::Getopt'      => 0;
requires 'IPC::System::Simple' => 0;
requires 'App::Cmd'            => 0;
requires 'Module::Setup'       => 0;
requires 'FindBin::libs'       => 0;
requires 'File::Slurp'         => 0;
requires 'File::HomeDir'       => 0;
requires 'Devel::EvalContext'  => 0;

# BootLoader Plugins
requires 'Text::SimpleTable' => 0;
requires 'File::Find::Rule'  => 0;
requires 'Term::ReadLine'    => 0;
requires 'JSON::XS'          => 0;
requires 'MIME::Types'       => 0;

# Controller Plugins (remove from core)
requires 'HTML::FillInForm'      => 0;
requires 'FormValidator::Simple' => 0;

# View Plugins (remove from core)

# Middleware
requires 'HTTP::MobileAgent'                  => 0;
requires 'Encode::JP::Mobile'                 => 0;
requires 'HTTP::MobileAgent::Plugin::Charset' => 0;
requires 'Data::Visitor::Encode'              => 0;

if (HAVE_MP) {
    Apache::TestMM::filter_args();

    #Apache::TestMM::generate_script('t/integration/modperl/TEST');
    Apache::TestMM::generate_script('t/TEST');
    tests('t/integration/modperl/*.t t/performance/020_modperl/*.t');
}
else {
    tests('t/*.t t/unit/*.t t/unit/*/*.t');
    author_tests('xt');
}

test_requires 'Test::More'                   => 0;
test_requires 'Test::Differences'            => 0;
test_requires 'Test::Deep'                   => 0;
test_requires 'Test::Exception'              => 0;
test_requires 'Test::MockObject'             => 0;
test_requires 'Test::Class'                  => 0;
test_requires 'Test::TCP'                    => 0;
test_requires 'LWP::UserAgent'               => 0;
test_requires 'Module::Load::Conditional'    => 0;
test_requires 'Carp::Always'                 => 0;
test_requires 'Module::Install::AuthorTests' => 0;

install_script 'bin/angelos';

use_test_base;
auto_include;
WriteAll;


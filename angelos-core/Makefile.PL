use strict;
use warnings;

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
all_from 'lib/Angelos/Core.pm';

requires(

    # Basics
    'Class::Method::Modifiers'          => 0,
    'Class::Method::Modifiers::Fast'    => 0,
    'Mouse'                             => '0.17',
    'MouseX::Types'                     => '0.01',
    'HTTP::Engine'                      => '0.1.4',
    'HTTP::Engine::Middleware'          => '0.09',
    'HTTP::Router'                      => 0,
    'HTTP::Session'                     => '0.30',
    'Module::Pluggable::Object'         => 0,
    'UNIVERSAL::require'                => 0,
    'Log::Dispatch::Config'             => 0,
    'Log::Dispatch::Configurator'       => 0,
    'Log::Dispatch::Configurator::YAML' => 0,
    'Log::Dispatch::Colorful'           => 0,
    'String::CamelCase'                 => 0,
    'Path::Class'                       => 0,
    'Devel::InnerPackage'               => 0,
    'Exception::Class'                  => 0,
    'File::Spec'                        => 0,
    'IO::Pager'                         => 0,
    'Params::Validate'                  => 0,
    'Data::Util'                        => 0,
    'Class::Singleton'                  => 0,

    # Angelos Plugins
    'Text::SimpleTable' => 0,
    'File::Find::Rule'  => 0,

    # Config
    'Kwalify'                 => 0,
    'YAML'                    => 0,
    'Data::Visitor::Callback' => 0,

    # Script
    'Pod::Simple::Text'   => 0,
    'MouseX::Getopt'      => '0.04',
    'IPC::System::Simple' => 0,
    'App::Cmd'            => '0.202',
    'Module::Setup'       => 0,
    'FindBin::libs'       => 0,
    'File::Slurp'         => 0,
    'File::HomeDir'       => 0,
    'Devel::EvalContext'  => 0,
    'JSON::XS'            => 0,
    'Term::ReadLine'      => 0,

    # Components
    'Template' => 0,

    # I18N
    'Locale::Maketext::Simple'  => 0,
    'Locale::Maketext::Extract' => 0,

    # testing
    'HTTP::Request::Common' => 0,
    'Test::Class'           => 0,
    'Test::Base'            => 0,

    # View Plugins (remove from core)

    # Core Middleware
    'MIME::Types' => 0,
);

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

test_requires(
    'Test::LoadAllModules'         => '0.02',
    'Test::Most'                   => '0.21',
    'Test::Class'                  => 0,
    'Test::MockObject'             => 0,
    'Test::TCP'                    => 0,
    'LWP::UserAgent'               => 0,
    'Module::Load::Conditional'    => 0,
    'Carp::Always'                 => 0,
    'Module::Install::AuthorTests' => 0,
);

install_script 'bin/angelos';

use_test_base;
auto_include;
WriteAll;

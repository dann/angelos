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
all_from 'lib/Angelos.pm';

requires(
    # Basics
    'Mouse'                             => '0.14',
    'HTTP::Engine'                      => 0,
    'HTTP::Router'                      => 0,
    'HTTP::Session'                     => 0,
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
    'Class::Singleton'                  => 0,
    'Params::Validate'                  => 0,
    'Class::Method::Modifiers::Fast'    => 0,

    # Config
    'Kwalify'                 => 0,
    'YAML'                    => 0,
    'Data::Visitor::Callback' => 0,

    # Script
    'Pod::Simple::Text'   => 0,
    'MouseX::Getopt'      => 0,
    'IPC::System::Simple' => 0,
    'App::Cmd'            => 0,
    'Module::Setup'       => 0,
    'FindBin::libs'       => 0,
    'File::Slurp'         => 0,
    'File::HomeDir'       => 0,
    'Devel::EvalContext'  => 0,

    # BootLoader Plugins
    'Text::SimpleTable' => 0,
    'File::Find::Rule'  => 0,
    'Term::ReadLine'    => 0,
    'JSON::XS'          => 0,
    'MIME::Types'       => 0,

    # Components
    'Template' => 0,

    # I18N
    'Locale::Maketext::Simple'  => 0,
    'Locale::Maketext::Extract' => 0,

    # Controller Plugins (remove from core)
    'HTML::FillInForm'      => 0,
    'FormValidator::Simple' => 0,

    # View Plugins (remove from core)

    # Middleware
    'HTTP::MobileAgent'                  => 0,
    'Encode::JP::Mobile'                 => 0,
    'HTTP::MobileAgent::Plugin::Charset' => 0,
    'Data::Visitor::Encode'              => 0,
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
    'Test::More'                   => 0,
    'Test::Differences'            => 0,
    'Test::Deep'                   => 0,
    'Test::Exception'              => 0,
    'Test::MockObject'             => 0,
    'Test::Class'                  => 0,
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

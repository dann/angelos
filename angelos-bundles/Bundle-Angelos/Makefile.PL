use strict;
use warnings;
use inc::Module::Install 0.67;
name 'Bundle-Angelos';
all_from 'lib/Bundle/Angelos.pm';

requires( 
    'Angelos-Core' => 0, 
);

features(
#    'FormValiator Support' => [
#        -default                                             => 0,
#        'Angelos::Controller::Plugin::FormValidator::Simple' => '0'
#    ],
    'Template::Toolkit Support' => [
        -default            => 0,
        'Angelos::View::TT' => '0'
    ],
    'SQLite Support (WARNING: requires a C compiler!)' => [
        -default      => 0,
        'DBD::SQLite' => 0
    ],
);

build_requires 'Test::More';
auto_install;
auto_include;
WriteAll;

package TestApp::Config;
use base 'Angelos::Config';
use Angelos::ProjectStructure;

sub config_file {
    Angelos::ProjectStructure->new( home => TestApp::Home->instance )
        ->config_file;
}

1;

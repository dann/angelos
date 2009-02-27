package TestApp::Config;
use base 'Angelos::Config';
use Angelos::ProjectStructure;
use TestApp::Home;

sub config_file_path {
    Angelos::ProjectStructure->new( home => TestApp::Home->instance )
        ->config_file_path;
}

1;

package TestApp::Logger;
use base 'Angelos::Logger';
use Angelos::ProjectStructure;
use TestApp::Home;

sub app_class {
    'TestApp';
}

sub logger_config_file_path {
    Angelos::ProjectStructure->new( home => TestApp::Home->instance )
        ->logger_config_file_path;
}

1;

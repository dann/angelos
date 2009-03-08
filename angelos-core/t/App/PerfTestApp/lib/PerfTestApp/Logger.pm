package PerfTestApp::Logger;
use base 'Angelos::Logger';
use Angelos::ProjectStructure;
use PerfTestApp::Home;

sub app_class { 'PerfTestApp'; }

sub logger_config_file_path {
    Angelos::ProjectStructure->new( home => PerfTestApp::Home->instance )
        ->logger_config_file_path;
}

1;

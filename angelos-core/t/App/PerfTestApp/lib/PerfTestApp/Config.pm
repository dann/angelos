package PerfTestApp::Config;
use base 'Angelos::Config';
use Angelos::ProjectStructure;

sub config_file_path {
    my $self = shift;
    Angelos::ProjectStructure->new( home => PerfTestApp::Home->instance )
        ->config_file_path;
}

1;

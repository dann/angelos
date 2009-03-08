package TestApp::I18N;
use base 'Angelos::I18N';
use Angelos::ProjectStructure;
use TestApp::Home;

sub app_class {
    'TestApp';
}

sub po_dir {
    Angelos::ProjectStructure->new( home => TestApp::Home->instance )->po_dir;
}

1;

package TestApp::Schema;
use Mouse;
use TestApp::Config;
extends qw(Angelos::ORM::DBIC::Schema);
__PACKAGE__->load_classes();

sub config {
    TestApp::Config->instance;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

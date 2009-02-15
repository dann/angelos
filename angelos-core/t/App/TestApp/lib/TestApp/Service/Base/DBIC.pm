package TestApp::Service::Base::DBIC;
use Mouse;
extends 'TestApp::Service::Base';

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

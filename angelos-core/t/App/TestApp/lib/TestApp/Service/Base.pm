package TestApp::Service::Base;
use Mouse;

with 'TestApp::Role::Configurable';
with 'TestApp::Role::Loggable';
with 'TestApp::Role::HomeAware';

no Mouse;
__PACKAGE__->meta->make_immutable;
1;

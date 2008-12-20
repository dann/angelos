use strict;
use Test::More tests => 3;
use Data::Dumper;
use lib 't/lib';

BEGIN { use_ok 'Angelos::Component::Loader' }

{
    my $components
        = Angelos::Component::Loader->new->load_components('TestApp::Web');
    my @component_keys = keys %{$components};
    is @component_keys, 2;
}

{
    my $loader = Angelos::Component::Loader->new;
    $loader->load_components('TestApp::Web');
    my $controller = $loader->search_controller('Root');
    is ref $controller, 'TestApp::Web::Controller::Root';
}


use strict;
use warnings;
use lib 'lib', 't/lib';

AngelosTest->runtests;

package AngelosTest;
use base qw/Angelos::Test/;
use Test::More;

sub dummy: Tests {
    ok 1;
}

1;


#{
#    my $components
#        = Angelos::Component::Loader->new->load_components('TestApp::Web');
#    my @component_keys = keys %{$components};
#    is @component_keys, 2;
#}

#{
#    my $loader = Angelos::Component::Loader->new;
#    $loader->load_components('TestApp::Web');
#    my $controller = $loader->search_controller('Root');
#    is ref $controller, 'TestApp::Web::Controller::Root';
#}


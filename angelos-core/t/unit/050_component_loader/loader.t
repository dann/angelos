#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;

use lib File::Spec->catdir('t', 'lib');

AngelosTest->runtests;

package AngelosTest;
use strict;
use warnings;
use Angelos::Test;
use base qw(Angelos::Test::Class);

sub use_test : Tests {
    use_ok 'Angelos';
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


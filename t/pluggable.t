use strict;
use warnings;
use lib 't/lib';

use Test::More tests => 1;                      # last test to print
use TestApp::Web::Controller::Root;

use App;
use TestRole;
my $controller = TestApp::Web::Controller::Root->new;
$controller->load_plugin('Dumper');
$controller->dump('hello');

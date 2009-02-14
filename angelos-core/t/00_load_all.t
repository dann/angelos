use strict;
use warnings;
use Test::More ();

Test::More::plan('no_plan');

use Module::Pluggable::Object;

my $finder = Module::Pluggable::Object->new( search_path => ['Angelos'], );

foreach my $class (
    grep !
    /\.ToDo|Angelos::Engine::ModPerl|Angelos::Component|HTPro|JobQueue|Angelos::Middleware::|Angelos::Plugin/,
    sort do { local @INC = ('lib'); $finder->plugins }
    )
{
    Test::More::use_ok($class);
}


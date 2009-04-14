use strict;
use warnings;
use Test::LoadAllModules;
use TAP::Harness::JUnit;

BEGIN {
    all_uses_ok(
        search_path => 'Angelos',
        except      => [
            'Angelos::Engine::ModPerl', 'Angelos::Component',
            'Angelos::Middleware::.*',  'Angelos::Plugin',
            'Angelos::Test',
        ]
    );
}


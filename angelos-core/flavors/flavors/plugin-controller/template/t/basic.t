use strict;
use warnings;
use t::Utils;

plan tests => 2 * blocks;

run_tests;

__END__
=== test1
--- path : /
--- response_code : 200
--- response_body
ok

=== test2 
--- path : /
--- response_code : 200
--- response_body
ok



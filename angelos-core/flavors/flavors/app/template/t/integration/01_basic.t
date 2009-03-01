use strict;
use warnings;
use FindBin::libs;
use Angelos::Test::Base;

plan tests => 1 * blocks;

run_tests;

sub check_response {
    my ($response, $expected_response) = @_; 
    is $response->code, $expected_response->code;
}

sub test_application_class {
    '[% module %]';
}

__END__

=== one
--- request
method: GET
path: /
--- response
code: 200


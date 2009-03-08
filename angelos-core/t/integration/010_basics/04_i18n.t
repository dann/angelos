use strict;
use warnings;
use FindBin::libs;
use lib glob File::Spec->catfile( 't', 'App', '*', 'lib' );
use Angelos::Test::Base;

plan tests => 1 * blocks;

run_tests;

sub check_response {
    my ($response, $expected_response) = @_;
    is $response->body, $expected_response->body;
}

sub test_application_class {
    'TestApp';
}

__END__

=== simple
--- request
method: GET
path: /localizer/japanese
--- response
code: 'こんにちは'

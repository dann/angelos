use strict;
use warnings;
use FindBin::libs;
use lib glob File::Spec->catfile( 't', 'App', '*', 'lib' );
#use Angelos::Test::Utils;
use Angelos::Test::Base;

plan tests => 1 * blocks;

run_tests;

sub check_response {
    my ($response, $expected_response) = @_;
    is $response->code, $expected_response->code;
}

sub test_application_class {
    'TestApp';
}

__END__

=== one
--- request
method: GET
path: /root/index
params:
  hoge: hoge
  bar:  foo
--- response
body: 'hoge'
status: 200


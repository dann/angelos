use strict;
use Test::More;

if ( !$ENV{TEST_CRITIC} ) {
    plan(
        skip_all => "Set TEST_CRITIC environment variable to run this test" );
}
else {
    eval {
        require Test::Perl::Critic;
        require Perl::Critic;
        die "oops. very old." if $Perl::Critic::VERSION < 1.082;
        Test::Perl::Critic->import( -profile => 'xt/perlcriticrc' );
    };
    plan skip_all => "Test::Perl::Critic >= 1.082 is not installed." if $@;
    all_critic_ok('lib');
}


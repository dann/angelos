package Angelos::Test::Base;
use Test::Base -Base;
use UNIVERSAL::require;
use Carp ();

our @EXPORT = qw/run_tests/;

sub run_tests {
    filters { request => [qw/request/], response => [qw/response/] };
    run {
        my $block    = shift;
        my $request  = $block->request;
        my $app      = make_application();
        my $response = $app->run($request);
        main::check_response( $response, $block->response );
    };
}

sub make_application {
    my $application_class = main::test_application_class();
    $application_class->require;
    my $app = $application_class->new( server => 'Test', );
    $app;
}

package Angelos::Test::Base::Filter;
use strict;
use warnings;
use Test::Base::Filter -base;
use HTTP::Request;
use HTTP::Engine::Response;
use HTTP::Request::Common;
use YAML;
use Carp ();

sub request {
    $self->assert_scalar(@_);
    my $args = YAML::Load(shift);
    Carp::croak 'path must be set'   unless $args->{path};
    Carp::croak 'method must be set' unless $args->{method};

    my $sub = HTTP::Request::Common->can( $args->{method} );

    my $uri = $args->{uri};
    $uri ||= 'http://localhost' . $args->{path};

    $sub->( $uri, $args->{headers}, Content => $args->{content} )

}

sub response {
    $self->assert_scalar(@_);
    my $args = YAML::Load(shift);
    return HTTP::Engine::Response->new($args)->as_http_response;
}

1;

package t::Utils;
use FindBin::libs;
use lib File::Spec->catfile( 't', 'TestApp', 'lib' );
use Test::Base -Base;
use Test::TCP;
use LWP::UserAgent;
use TestApp;

our @EXPORT = qw/run_tests/;

sub run_tests {
    filters { response_body => [qw/chomp/], };
    run {
        my $block = shift;

        test_tcp(
            client => sub {
                my $port = shift;
                my $ua   = LWP::UserAgent->new;
                my $res = $ua->get("http://localhost:$port" . $block->path);
                is $res->code,    $block->response_code;
                is $res->content, $block->response_body;
            },
            server => sub {
                my $port = shift;
                my $app  = TestApp->new(
                    server => 'ServerSimple',
                    port   => $port,
                );
                $app->setup;
                $app->run;
            },
        );

    }
}

1;

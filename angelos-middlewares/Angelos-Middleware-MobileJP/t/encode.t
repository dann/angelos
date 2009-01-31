use strict;
use warnings;
use lib '.';
use Test::Base;
eval q{ use HTTP::Request };
plan skip_all => "HTTP::Request is not installed" if $@;
eval q{ use HTTP::Engine };
plan skip_all => "HTTP::Engine is not installed: $@" if $@;
eval q{ use HTTP::Engine::Middleware };
plan skip_all => "HTTP::Engine::Middleware is not installed: $@" if $@;

plan tests => 3 * blocks;

use Encode;
use URI;

filters { params => [qw/eval/], };

run {
    my $block = shift;

    my $mw = HTTP::Engine::Middleware->new;
    $mw->install( 'Angelos::Middleware::MobileJP', );

    my $request = HTTP::Request->new( GET => $block->uri, );
    $request->user_agent( $block->ua );

    my $do_test = sub {
        my $req = shift;
        ok Encode::is_utf8( $req->params->{'nite'} );
        is_deeply $req->params, $block->params, $block->name;
        HTTP::Engine::Response->new( body => 'OK!' );
    };

    my $response = HTTP::Engine->new(
        interface => {
            module          => 'Test',
            request_handler => $mw->handler($do_test),
        },
    )->run($request);

    is $response->content, 'OK!';
};

__END__

=== ascii
--- uri: http://localhost/?nite=nipotan
--- ua : 'DoCoMo/1.0/D501i'
--- params : {nite => 'nipotan'}

=== utf-8
--- uri: http://localhost/?nite=%E3%81%97%E3%83%BC%E3%81%88%E3%81%99%E3%81%88%E3%81%99
--- ua : 'DoCoMo/1.0/D501i'
--- params: { nite => "\x{3057}\x{30fc}\x{3048}\x{3059}\x{3048}\x{3059}" }

=== euc-jp
--- uri: http://localhost/?nite=%A4%B7%A1%BC%A4%A8%A4%B9%A4%A8%A4%B9
--- ua : 'DoCoMo/1.0/D501i'
--- params: { nite => "\x{3057}\x{30fc}\x{3048}\x{3059}\x{3048}\x{3059}" }



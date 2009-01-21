HTTP::Router->define(
    sub {
        $_->match('/')->to( { controller => 'Root', action => 'index' } );
        $_->match('/tt')->to( { controller => 'Root', action => 'tt' } );
        $_->match('/japanese')->to( { controller => 'Root', action => 'japanese' } );
        $_->match('/forward_test')->to( { controller => 'Root', action => 'forward' } );
        $_->match('/detach_test')->to( { controller => 'Root', action => 'detach' } );
#        $_->match('/middlewareunicode')
#            ->to( { controller => 'MiddlewareUnicode', action => 'index' } );
        $_->resources('Book');
    }
);


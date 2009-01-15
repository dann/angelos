HTTP::Router->define(
    sub {
        $_->match('/')->to( { controller => 'Root', action => 'index' } );
        $_->match('/japanese')->to( { controller => 'Root', action => 'japanese' } );
#        $_->match('/middlewareunicode')
#            ->to( { controller => 'MiddlewareUnicode', action => 'index' } );
#        $_->resources('Book');
    }
);


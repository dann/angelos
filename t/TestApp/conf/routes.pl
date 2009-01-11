HTTP::Router->define(
    sub {
        $_->match('/')->to( { controller => 'Root', action => 'index' } );
#        $_->match('/middlewareunicode')
#            ->to( { controller => 'MiddlewareUnicode', action => 'index' } );
#        $_->resources('Book');
    }
);


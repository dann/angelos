HTTP::Router->define(
    sub {
        $_->match('/')->to( { controller => 'Root', action => 'index' } );
        $_->match('/tt')->to( { controller => 'Root', action => 'view' } );
    }
);


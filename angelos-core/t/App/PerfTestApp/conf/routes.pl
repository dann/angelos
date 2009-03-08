HTTP::Router->define(
    sub {
        $_->match('/root/index')->to( { controller => 'Root', action => 'index' } );
    }
);


HTTP::Router->define(
    sub {
        $_->match('/')->to( { controller => 'Root', action => 'index' } );
        $_->resources('Book');
        $_->resources('Users', sub {
                $_->resources('Articles');
            }
        );
    }
);


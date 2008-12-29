HTTP::Router->define(sub {
    $_->match({path => '/'})->to(
        { controller => 'root', action=>'index' }
    );
    $_->resources('Book');
    $_->resources('Users', sub {
        $_->resources('Articles');
    }); 
});


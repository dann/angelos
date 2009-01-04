HTTP::Router->define(
    sub {
        $_->resources('Users', sub {
                $_->resources('Articles');
            }
        );
    }
);


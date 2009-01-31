HTTP::Router->define(
    sub {
        $_->match('/{controller}/{action}/{id}.{format}')->register;
        $_->match('/{controller}/{action}/{id}')->register;
    }
);


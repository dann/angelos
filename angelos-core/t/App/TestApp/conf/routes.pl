HTTP::Router->define(
    sub {

        $_->match('/root/')->to({controller=>'Root', action => 'index'});
        $_->match('/root/error')->to({controller=>'Root', action => 'error'});
        # $_->match('/{controller}/{action}/{id}.{format}')->register;
        # $_->match('/{controller}/{action}/{id}')->register;
    }
);


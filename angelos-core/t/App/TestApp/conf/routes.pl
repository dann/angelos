HTTP::Router->define(
    sub {
        $_->match('/{controller}/{action}')->register

        #$_->match('/root/index')->to({controller=>'Root', action => 'index'});
        #$_->match('/root/error')->to({controller=>'Root', action => 'error'});
        #$_->match('/root/tt')->to({controller=>'Root', action => 'tt'});
        #$_->match('/root/forward_test')->to({controller=>'Root', action => 'forward_test'});
        #$_->match('/root/detach_test')->to({controller=>'Root', action => 'detach_test'});

        # $_->match('/{controller}/{action}/{id}.{format}')->register;
        # $_->match('/{controller}/{action}/{id}')->register;
    }
);


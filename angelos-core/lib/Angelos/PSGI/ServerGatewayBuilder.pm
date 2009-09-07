package Angelos::PSGI::ServerGatewayBuilder;
use strict;
use warnings;

sub build {
    my ( $class, $module, $args ) = @_; 
    if ( $module !~ s{^\+}{} ) {         $module = join( '::', "Plack", "Impl", $module );
    }   
    Mouse::load_class($module);

    # FIXME need to develop standalone Plack::Impl wrapper
    # looks  ugly...
    # we need to wrap Plack::Impl or
    if ( $module eq 'Plack::Impl::ServerSimple' ) { 
        my $server = $module->new( $args->{port} );
        $server->host( $args->{host} );
        $server->psgi_app( $args->{psgi_handler} );
        return $server;
    }   

    if ( $module eq 'Plack::Impl::AnyEvent' ) { 
        $module->new( port => $args->{port}, host => $args->{host} );
        return $module;
    }   
}

1;



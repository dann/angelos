#!/usr/bin/perl
use strict;
use warnings;
use FindBin::libs;
use Angelos::Script::Server;
use Angelos::Debug::MemoryUsage;

# FIXME
Angelos::Debug::MemoryUsage->reset;
Angelos::Script::Server->new( app => 'TestApp::Web' )->run();
END {
    Angelos::Debug::MemoryUsage->show;
}

__END__

=head1 NAME

Angelos Server - Angelos web server

=head1 SYNOPSIS

  angelos-server.pl --port=PORT --host=HOST --app=APP_CLASS_NAME

  --port PORT
    specifies the port number it listens to. Default: 10010

  --host HOST
    specifies the host address it binds to (e.g. 127.0.0.1). Default to any address.

  --app APP_CLASS_NAME 
    specifies the application class name. ex) MyApp 

=head1 AUTHOR

Takatoshi Kitano

=cut

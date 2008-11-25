#!/usr/bin/perl
use strict;
use warnings;
use FindBin::libs;
use Angelos::Script::Server;

Angelos::Script::Server->new_with_options->run();

__END__

=head1 NAME

Angelos Server - Angelos web server

=head1 SYNOPSIS

  remedie-server.pl --port=PORT --host=HOST

  --port PORT
    specifies the port number it listens to. Default: 10010

  --host HOST
    specifies the host address it binds to (e.g. 127.0.0.1). Default to any address.

=head1 AUTHOR

Takatoshi Kitano

=cut

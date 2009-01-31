package Angelos;
use 5.00800;
our $VERSION = '0.01';
use Angelos::Class;
use Angelos::BootLoader;
use Angelos::MIMETypes;

has 'engine' => ( is => 'rw', );

has 'appclass' => ( is => 'rw', );

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'port' => (
    is      => 'rw',
    isa     => 'Int',
    default => 3000,
);

has 'server' => ( is => 'rw', );

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0
);

# This attribute is used for test only
has 'request_handler' => ( is => 'rw', );

sub setup {
    my $self       = shift;
    my $bootloader = Angelos::BootLoader->new(
        appclass => ref $self,
        host     => $self->host,
        port     => $self->port,
        server   => $self->server,
        debug    => $self->debug,
    );
    my $engine = $bootloader->run;
    $engine->request_handler( $self->request_handler )
        if $self->request_handler;
    $self->engine($engine);
}

sub run {
    my $self = shift;
    $self->engine->run;
}

our $MIMETYPES;

sub available_mimetypes {
    $MIMETYPES = Angelos::MIMETypes->new;
    $MIMETYPES;
}

__END_OF_CLASS__

__END__

=head1 NAME

Angelos -

=head1 SYNOPSIS

  package MyApp;
  use Angelos::Class;
  extends 'Angelos';

  __END_OF_CLASS__

  use MyApp;
  my $app = MyApp->new;
  $app->setup;
  $app->run;
  1;

Edit conf/routes.yaml to make dispatch rules and create an application class like below.

=head1 DESCRIPTION

Angelos is yet another web application framework

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 CONTRIBUTORS

Many people have contributed ideas, inspiration, fixes and features to
the Angelos.  Their efforts continue to be very much appreciated.
Please let me know if you think anyone is missing from this list.

Lyo Kato, Tomyhero Teranishi, vkgtaro, hideden, bonnu

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

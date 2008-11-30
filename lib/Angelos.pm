package Angelos;
use strict;
use warnings;
our $VERSION = '0.01';
use Carp ();
use Moose;
use MooseX::Types::Path::Class qw(File Dir);
use Angelos::Server;
use Angelos::Utils;
use Angelos::Component::Loader;

has 'conf' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    isa      => Dir,
    required => 1,
    coerce   => 1,
    default  => sub { Angelos::Utils->path_to('root')->absolute },
);

has 'host' => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has 'port' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 10070,
    required => 1,
);

has 'server' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'ServerSimple',
);

has 'component_loader' => (
    is => 'rw',
    default => sub {
        Angelos::Component::Loader->new;
    }
);

sub BUILD {
    my $self   = shift;
    my $exit   = sub { CORE::die('caught signal') };
    my $server = $self->setup;
    eval {
        local $SIG{INT}  = $exit;
        local $SIG{QUIT} = $exit;
        local $SIG{TERM} = $exit;
        $server->run;
    };
}

sub setup {
    my $self   = shift;
    my $server = Angelos::Server->new(
        root   => $self->root,
        host   => $self->host,
        port   => $self->port,
        server => $self->server,
        conf   => $self->conf,
    );
    $self->setup_dispatcher($server);
    $self->setup_components;
    $server;
}

sub setup_components {
    my $self = shift;
    $self->component_loader->load_components(ref $self);
}

sub setup_dispatcher {
    my ($self, $server);
    $self->_setup_dispatch_rules($server);
}

sub _setup_dispatch_rules {
    my ( $self, $server ) = @_;
    return [] unless $self->build_dispatch_rules;
    $server->dispatcher->add_rule($_) for @{ $self->build_dispatch_rules };
}

sub build_dispatch_rules {
    Carp::croak('Method "build_dispatch_rules" not implemented by subclass');
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Angelos -

=head1 SYNOPSIS

  package MyApp;
  use Moose;
  extends 'Angelos'

  sub build_dispatch_rules {
  }

=head1 DESCRIPTION

Angelos is

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

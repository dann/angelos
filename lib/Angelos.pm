package Angelos;
use strict;
use warnings;
our $VERSION = '0.01';

use Moose;
use MooseX::Types::Path::Class qw(File Dir);
use Angelos::Engine;
use Angelos::Loader;

has 'conf' => ( is => 'rw', );

has 'root' => (
    is       => 'rw',
    isa      => Dir,
    required => 1,
    coerce   => 1,
    default  => sub { Path::Class::Dir->new('root')->absolute },
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

has 'engine' => (
    traits      => ['Getopt'],
    cmd_aliases => 'h',
    is          => 'rw',
    isa         => 'Str',
    default     => 'ServerSimple',
);

sub BUILD {
    my ($self) = @_;
    my $exit = sub { CORE::die('caught signal') };
    my $engine = $self->setup;
    eval {
        local $SIG{INT}  = $exit;
        local $SIG{QUIT} = $exit;
        local $SIG{TERM} = $exit;
        $engine->run;
    };
}

sub setup {
    my ($self) = @_;
    $self->load_modules;
    my $engine = Angelos::Engine->new(
        root   => $self->root,
        host   => $self->host,
        port   => $self->port,
        engine => $self->engine,
        conf   => $self->conf,
    );
    $engine->dispatcher->add_rule($_) for $self->setup_dispatch_rules;
}

# move to Angelos::Engine
sub load_modules {
    my ($self) = @_;
    Angelos::Loader->new->load( conf => $self->conf );
}

sub setup_dispatch_rules {
    die 'Implement me!';
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

  sub setup_dispatch_rules {
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

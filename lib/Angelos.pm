package Angelos;
use strict;
use warnings;
our $VERSION = '0.01';

use Moose;
use Angelos::Engine;
use Angelos::Loader;

has 'conf' => (
    is => 'rw',
);

sub BUILD {
    my ( $self ) = @_;
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
    my ( $self ) = @_;
    $self->load_modules;
    my $engine = Angelos::Engine->new( conf => $self->conf );
    $engine->dispatcher->add_rule($_) for $self->setup_dispatch_rules; 
}

# move to Angelos::Engine
sub load_modules {
    my ( $self ) = @_;
    Angelos::Loader->new->load( conf=>$ $self->conf); 
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

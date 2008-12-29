package HTTP::Router::Mapper;

use Moose;
use Hash::Merge qw(merge);
use HTTP::Router::Route;
use HTTP::Router::Routes;
use namespace::clean -except => ['meta'];

with 'HTTP::Router::Resources';

has 'routeset' => (
    is       => 'rw',
    isa      => 'HTTP::Router::Routes',
    required => 1,
);

has 'route' => (
    is        => 'rw',
    isa       => 'HTTP::Router::Route',
    predicate => 'has_route',
);

has 'path' => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
    lazy    => 1,
);

has 'conditions' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
    lazy    => 1,
);

has 'params' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
    lazy    => 1,
);

sub freeze {
    my $self = shift;

    my $route = HTTP::Router::Route->new(
        path       => $self->path,
        params     => $self->params,
        conditions => $self->conditions,
    );

    $self->routeset->push($route);
    $self->route($route);

    return $self;
}

sub clone {
    my ($self, %params) = @_;
    return $self->meta->clone_instance($self, %params, routeset => $self->routeset);
}

sub match {
    my $self = shift;
    return $self if $self->has_route;

    my $block = ref $_[-1] eq 'CODE' ? pop : undef;
    my ($path, $conditions) = @_;

    my $mapper = $self->clone(
        path       => $self->path . $path,
        conditions => merge($conditions || {}, $self->conditions),
        params     => $self->params,
    );
    if ($block) {
        local $_ = $mapper;
        $block->($_);
    }

    return $mapper;
}

#sub namespace {}

sub to {
    my $self = shift;
    return $self if $self->has_route;

    my $block = ref $_[-1] eq 'CODE' ? pop : undef;
    my $params = shift || {};

    my $mapper = $self->clone(
        path       => $self->path,
        conditions => $self->conditions,
        params     => merge($params, $self->params),
    );
    if ($block) {
        local $_ = $mapper;
        $block->($_);
    }
    else {
        $mapper->freeze;
    }

    return $mapper;
}

# alias 'with' and 'register' => 'to'
__PACKAGE__->meta->add_method(with     => __PACKAGE__->can('to'));
__PACKAGE__->meta->add_method(register => __PACKAGE__->can('to'));

#sub name {}

no Moose; __PACKAGE__->meta->make_immutable;

=for stopwords params routeset

=head1 NAME

HTTP::Router::Mapper

=head1 SYNOPSIS

  my $router = HTTP::Router->define(sub {
      $_->match('/index.{format}')
          ->to({ controller => 'Root', action => 'index' });

      $_->match('/archives/{year}', { year => qr/\d{4}/ })
          ->to({ controller => 'Archive', action => 'by_month' });

      $_->match('/account/login', { method => ['GET', 'POST'] })
          ->to({ controller => 'Account', action => 'login' });

      $_->with({ controller => 'Account' }, sub {
          $_->match('/account/signup')->to({ action => 'signup' });
          $_->match('/account/logout')->to({ action => 'logout' });
      });

      $_->match('/')->register;
  });

=head1 METHODS

=head2 match($path, $conditions?, $block?)

=head2 to($params?, $block?)

=head2 with($params?, $block?)

=head2 register

=head1 PROPERTIES

=head2 routeset

=head2 route

=head2 path

=head2 conditions

=head2 params

=head1 INTERNALS

=head2 freeze

=head2 clone

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTTP::Router>, L<HTTP::Router::Route>

=cut

package HTTP::Router::Resources;

use Moose::Role;
use Hash::Merge qw(merge);
use Lingua::EN::Inflect::Number qw(to_S to_PL);
use String::CamelCase qw(camelize decamelize);
use namespace::clean -except => ['meta'];

sub resources {
    my $self = shift;

    my $block = ref $_[-1] eq 'CODE' ? pop : undef;
    my ($name, $args) = @_;

    my $path     = decamelize $name;
    my $params   = { controller => $args->{controller} || camelize(to_PL($path)) };
    my $singular = $args->{singular} || to_S($path);
    my $id       = "${singular}_id";

    my $collections = merge($args->{collection} || {}, {
        index  => { method => 'GET',  path => '' },
        create => { method => 'POST', path => '' },
        post   => { method => 'GET',  path => '/new' },
    });

    my $members = merge($args->{member} || {}, {
        show    => { method => 'GET',    path => '' },
        update  => { method => 'PUT',    path => '' },
        destroy => { method => 'DELETE', path => '' },
        edit    => { method => 'GET',    path => '/edit' },
    });

    $self->match("/${path}")->to($params, sub {
        # collections
        while (my ($action, $args) = each %$collections) {
            my $path   = ref $args eq 'HASH' ? $args->{path}   : "/${action}";
            my $method = ref $args eq 'HASH' ? $args->{method} : $args;
            my $conditions = { method => $method };
            my $params     = { action => $action };
            $_->match("${path}.{format}", $conditions)->to($params);
            $_->match("${path}",          $conditions)->to($params);
        }

        # members
        $_->match("/{$id}", sub {
            while (my ($action, $args) = each %$members) {
                my $path   = ref $args ? $args->{path}   : "/${action}";
                my $method = ref $args ? $args->{method} : $args;
                my $conditions = { method => $method };
                my $params     = { action => $action };
                $_->match("${path}.{format}", $conditions)->to($params);
                $_->match("${path}",          $conditions)->to($params);
            }
        });
    });

    if ($block) {
        local $_ = $self->clone(
            path       => $self->path . "/${path}/{$id}",
            conditions => $self->conditions,
            params     => $self->params,
        );
        $block->($_);
    }

    $self;
}

sub resource {
    my $self = shift;

    my $block = ref $_[-1] eq 'CODE' ? pop : undef;
    my ($name, $args) = @_;

    my $path   = decamelize $name;
    my $params = { controller => $args->{controller} || camelize($path) };

    my $members = merge($args->{member} || {}, {
        create  => { method => 'POST',   path => '' },
        show    => { method => 'GET',    path => '' },
        update  => { method => 'PUT',    path => '' },
        destroy => { method => 'DELETE', path => '' },
        post    => { method => 'GET',    path => '/new' },
        edit    => { method => 'GET',    path => '/edit' },
    });

    $self->match("/${path}")->to($params, sub {
        # members
        while (my ($action, $args) = each %$members) {
            my $path   = ref $args eq 'HASH' ? $args->{path}   : "/${action}";
            my $method = ref $args eq 'HASH' ? $args->{method} : $args;
            my $conditions = { method => $method };
            my $params     = { action => $action };
            $_->match("${path}.{format}", $conditions)->to($params);
            $_->match("${path}",          $conditions)->to($params);
        }
    });

    if ($block) {
        local $_ = $self->clone(
            path       => $self->path . "/${path}",
            conditions => $self->conditions,
            params     => $self->params,
        );
        $block->($_);
    }

    $self;
}

no Moose::Role; 1;

=head1 NAME

HTTP::Router::Resources

=head1 SYNOPSIS

  use HTTP::Router;

  my $router = HTTP::Router->define(sub {
      $_->resources('users');

      $_->resource('account');

      $_->resources('members', sub {
          $_->resources('articles');
      });

      $_->resources('members', {
          controller => 'Users',
          collection => { login => 'GET' },
          member     => { settings => 'GET' },
      });
  });

=head1 METHODS

=head2 resources($name, $args?, $block?)

=head2 resource($name, $args?, $block?)

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTTP::Router::Mapper>, L<HTTP::Router>

=cut

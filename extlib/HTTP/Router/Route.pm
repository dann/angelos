package HTTP::Router::Route;

use Moose;
use MooseX::AttributeHelpers;
use Hash::Merge qw(merge);
use List::MoreUtils qw(any);
use Set::Array;
use URI::Template::Restrict;
use HTTP::Router::Match;
use namespace::clean -except => ['meta'];

has 'path' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    trigger  => sub {
        my ($self, $path) = @_;
        $self->parts([ split m!/! => $path ]);
        $self->templates(
            URI::Template::Restrict->new(template => $path)
        );
    },
);

has 'parts' => (
    metaclass => 'Collection::Array',
    is        => 'rw',
    isa       => 'ArrayRef[Str]',
    provides  => { count => 'part_size' },
);

has 'templates' => (
    is      => 'rw',
    isa     => 'URI::Template::Restrict',
    handles => ['variables'],
);

has 'params' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { +{} },
    lazy    => 1,
);

has 'conditions' => (
    is      => 'rw',
    isa     => 'HashRef[ Str | RegexpRef | ArrayRef ]',
    default => sub { +{} },
    lazy    => 1,
);

sub match {
    my ($self, $req) = @_;
    return unless blessed $req;

    my $path = $req->can('path') ? $req->path : do {
        if ($req->can('uri') and blessed($req->uri) and $req->uri->can('path')) {
            $req->uri->path;
        }
        else {
            undef;
        }
    };
    return unless defined $path;

    # part size
    my $size = scalar @{[ split m!/! => $path ]};
    return unless $size == $self->part_size;

    # path, captures
    my %vars = $self->templates->extract($path);
    if (%vars) {
        return unless $self->check_variable_conditions(\%vars);
    }
    else {
        return unless $path eq $self->path;
    }

    # conditions
    return unless $self->check_request_conditions($req);

    return HTTP::Router::Match->new(
        params   => merge(\%vars, $self->params),
        captures => \%vars,
        route    => $self,
    );
}

sub uri_for {
    my ($self, $captures) = @_;

    my $params = $captures || {};
    for my $name (keys %$params) {
        return unless $self->validate($params->{$name}, $self->conditions->{$name});
    }

    return $self->templates->process_to_string(%$params);
}

sub check_variable_conditions {
    my ($self, $vars) = @_;

    for my $name (keys %$vars) {
        return 0 unless $self->validate($vars->{$name}, $self->conditions->{$name});
    }

    return 1;
}

sub check_request_conditions {
    my ($self, $req) = @_;

    my $conditions = Set::Array->new(keys %{ $self->conditions });
    if ($self->variables) {
        $conditions->delete($self->variables);
    }

    for my $name (@$conditions) {
        return 0 unless my $code = $req->can($name);

        my $value = $code->();
        if ($name eq 'method') { # HEAD equals to GET
            $value = 'GET' if $value eq 'HEAD';
        }

        return 0 unless $self->validate($value, $self->conditions->{$name});
    }

    return 1;
}

sub validate {
    my ($self, $input, $expected) = @_;
    # arguments
    return 0 unless defined $input;
    return 1 unless defined $expected;
    # validation
    return $input =~ $expected             if ref $expected eq 'Regexp';
    return any { $input eq $_ } @$expected if ref $expected eq 'ARRAY';
    return $input eq $expected;
}

no Moose; __PACKAGE__->meta->make_immutable;

=for stopwords params

=head1 NAME

HTTP::Router::Route

=head1 METHODS

=head2 match($req)

=head2 uri_for($captures?)

=head1 PROPERTIES

=head2 path

=head2 params

=head2 conditions

=head2 variables

=head2 templates

=head1 INTERNALS

=head2 check_variable_conditions

=head2 check_request_conditions

=head2 validate

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<HTTP::Router>

=cut

package Angelos::Controller;

use Moose;
with qw(MooseX::Object::Pluggable Angelos::Component);

no Moose;

__PACKAGE__->meta->make_immutable;

1;

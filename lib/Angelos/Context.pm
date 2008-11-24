package Angelos::Context;
use Moose;
with 'MooseX::Object::Pluggable';

has 'app' => ( is => 'rw', required => 1 );
has 'req' => ( is => 'rw', required => 1 );
has 'res' => ( is => 'rw', required => 1 );

no Moose;

sub log {
}

# hmm. which class should this method have?
sub session {
}

sub render {
    my ($self, $options)    = @_;
    my $view =  $options->{view}|| 'TT';
    return $self->app->view($view)->render($options);
}

__PACKAGE__->meta->make_immutable;

1;

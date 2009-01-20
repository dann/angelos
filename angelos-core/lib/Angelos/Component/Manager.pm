package Angelos::Component::Manager;
use strict;
use warnings;
use Angelos::Component::Loader;
use base 'Class::Singleton';

sub _new_instance {
    my $class = shift;
    my $self = bless {}, $class;
    $self->{loader} = Angelos::Component::Loader->new;
    return $self;
}

sub setup {
    my ($self, $app_class) = @_;
    $self->{loader}->load_components($app_class);
}

sub search_controller {
    shift->{loader}->search_controller(@_);
}

sub search_model {
    shift->{loader}->search_model(@_);
}

sub search_view {
    shift->{loader}->search_view(@_);
}

sub set_component {
    shift->{loader}->set_component(@_);
}

sub get_component {
    shift->{loader}->get_component(@_);
}

1;

__END__

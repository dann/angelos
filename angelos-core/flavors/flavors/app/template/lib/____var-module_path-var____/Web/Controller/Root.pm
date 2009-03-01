package [% module %]::Web::Controller::Root;
use Angelos::Class;
extends 'Angelos::Controller';

sub index {
    my ($self, $params) = @_;
    $self->render(params => {name => 'Yamada Taro'});
}

__END_OF_CLASS__

__END__


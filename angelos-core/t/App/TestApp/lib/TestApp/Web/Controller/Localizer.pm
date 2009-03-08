package TestApp::Web::Controller::Localizer;
use Angelos::Class;
extends 'Angelos::Controller';
with 'TestApp::Role::Localizable';
use utf8;

sub japanese {
    my ($self, $params) = @_;
    # use Data::Dumper;
    # warn Dumper $self->res;
    $self->res->code(200);
    $self->loc_lang('ja');
    my $hello = $self->loc('Hello');
    # hmm ...
    warn $hello;
    $self->res->body($hello);
}

__END_OF_CLASS__

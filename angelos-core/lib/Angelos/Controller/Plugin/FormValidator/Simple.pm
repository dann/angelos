package Angelos::Controller::Plugin::FormValidator::Simple;
use Angelos::Plugin;
use FormValidator::Simple;
use Angelos::Config;
use Angelos::Exceptions;
 
=head1
 
plugins:
controller:
- module: FormValidator::Simple:
config:
profiles: __config(profiles.yaml)__
plugins:
-
-
 
=cut
 
# TODO
# Implement it later
# This is the concept implementation to decide plugin specification
 
after 'SETUP' => sub {
    my $self = shift;
    $self->__setup_formvalidator;
};

before 'ACTION' => sub {
    my ($self, $c, $action, $params) = @_;
    my $rule = $self->__select_validation_rule( $c->action );
    $self->__validate($c, $rule) if $rule;

    # TODO
    # Fill in form if validator detect validation errors?
    die 'Implement me';
};

after 'ACTION' => sub {
    my $self = shift;
};

sub __setup_formvalidator {
    my $self = shift;
    my $setting
        = $self->config->plugins( 'controller', 'FormValidator::Simple' );
    # setup FormValidator from config ?
    die 'Implement me';
}
 
sub __select_validation_rule {
    my ( $self, $action ) = @_;
 
    # decide validation rule from action
    die 'Implement me';
}
 
sub __validate {
    my ($self, $c, $rule) = @_;
    my $validator = FormValidator::Simple->new;
    $validator->check( $c->req, $rule );
    $c->stash->{form} = $validator->results;
}

1;

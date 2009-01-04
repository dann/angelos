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

hook 'AFTER_CONTROLLER_INIT' => sub {
    my $self = shift;
    $self->setup;
};

hook 'BEFORE_ACTION' => sub {
    my ( $self, $c ) = @_;
    my $rule = $self->select_validation_rule( $c->action );
    $self->_validate($c, $rule) if $rule;

    # TODO
    # Should we redirect to form page automatically?
};

hook 'AFTER_ACTION' => sub {
    my ( $self, $c ) = @_;

    # TODO
    # Fill in form if validator detect validation errors?
    die 'Implement me';
};

sub setup {
    my $setting
        = Angelos::Config->plugins( 'controller', 'FormValidator::Simple' );
    # setup FormValidator from config ?
    die 'Implement me';
}

sub _select_validation_rule {
    my ( $self, $action ) = @_;

    # decide validation rule from action
    die 'Implement me';
}

sub _validate {
    my ($self, $c, $rule) = @_;
    my $validator = FormValidator::Simple->new;
    $validator->check( $c->req, $rule );
    $c->stash->{form} = $validator->results;
}

1;

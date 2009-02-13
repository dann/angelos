package Angelos::Controller::Plugin::FormValidator::Simple;
use Angelos::Plugin;

use Angelos::Home;
use Angelos::Utils;
use Angelos::Exceptions;

use FormValidator::Simple;
use YAML;

has '__validator' => (
    is  => 'rw',
    isa => 'FormValidator::Simple',
);

has '__validator_profiles' => (
    is  => 'rw',
    isa => 'HashRef',
);

after SETUP => sub {

    my $self = shift;
    
    my $plugin_info = $self->config->plugins('controller', 'FormValidator::Simple');

    if ( $plugin_info && exists $plugin_info->{config} ) {
        my $conf = $plugin_info->{config};
        FormValidator::Simple->import( @{ $conf->{plugins} } )
            if exists $conf->{plugins};
        FormValidator::Simple->set_option( %{ $conf->{options} } )
            if exists $conf->{options};
        FormValidator::Simple->set_message_format( $conf->{message_format} )
            if exists $conf->{message_format};
    }

    $self->__validator_profiles({});

    # XXX: check this - auto processing
    my $stuff = $self->home->path_to(qw/conf validator.yaml/);
    open my $fh, '<:utf8', $stuff
        or return;
    my $config = eval {
        no warnings 'once';
        local $YAML::UseAliases = 0;
        YAML::Load( YAML::Dump( YAML::LoadFile($fh) ) );
    };
    close $fh;
    if ($@) {
        # error
    }

    my $messages = {};
    for my $controller ( keys %$config ) {
        for my $action ( keys %{ $config->{$controller} } ) {
            for my $profile ( keys %{ $config->{$controller}{$action} } ) {
                my $settings = $config->{$controller}{$action}{$profile};
                for my $setting ( @$settings ) {
                    unless (exists $self->__validator_profiles->{$controller}{$action}{$profile}) {
                        $self->__validator_profiles->{$controller}{$action}{$profile} = [];
                    }
                    push( @{ $self->__validator_profiles->{$controller}{$action}{$profile} }, 
                        $setting->{rule} ) if exists $setting->{rule};
                    $messages->{"$controller#$action"}{$profile} =
                        $setting->{message} if exists $setting->{message};
                }
            }
        }
    }
    FormValidator::Simple->set_messages($messages);

};

before ACTION => sub {

    my ($self, $c, $action, $params) = @_;

    my $v = FormValidator::Simple->new;
    
    my $controller = lc Angelos::Utils::class2classsuffix(ref $self); 
    $controller =~ s/^controller\:://;
    if ( exists $self->__validator_profiles->{$controller}
        && exists $self->__validator_profiles->{$controller}{$action} ) {
        my $profile = $self->__validator_profiles->{$controller}{$action};
        $v->check($c->request, [%$profile]);
    }

    $self->__validator($v);
};

after ACTION => sub {

    my ($self, $c, $action, $params) = @_;
    #$self->__validator(undef);

    # actionの中でview("TT")->renderされるので
    # ここで詰め込んでたら遅い
    #if ($self->__validator->has_error) {
    #    $c->stash->{form} = $self->__validator->results;
    #}

};

sub form {
    my $self = shift;
    if ($_[0]) {
        my $form = $_[1] ? [@_] : $_[0];
        $self->__validator->check($self->context->request, $form);
    }
    return $self->__validator->results;
}



1;

=head1 NAME 

Angelos::Controller::Plugin::FormValidator::Simple - formvalidator plugin for Angelos.

=head1 SYNOPSIS

config

    plugins
      controller
       - module: FormValidator::Simple
        

controller

    package MyController;
    with 'Angelos::Controller';

=head1 DESCRIPTION

=head1 METHODS

=head1 TODO

More Tests
More Documents

=head1 SEE ALSO

L<FormValidator::Simple>,
L<Catalyst::Plugin::FormValidator::Simple>,
L<Catalyst::Plugin::FormValidator::Simple::Auto>

=head1 AUTHOR

Lyo Kato, C<lyo.kato@gmail.com>

=head1 LICENSE

=cut

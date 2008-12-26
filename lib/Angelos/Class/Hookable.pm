package Angelos::Class::Hookable;
use strict;
no warnings 'redefine';
use Mouse::Role;
use Scalar::Util ();
use Carp;

has __hooks => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);

has __trigger_plugin_ns => (
    is => 'rw',
    required => 1,
    isa => 'Str',
    default => sub{ 'Plugin' },
);

has __trigger_plugin_app_ns => (
    is => 'rw',
    required => 1,
    isa => 'Str',
    default => sub{ 
        Scalar::Util::blessed shift; 
    },
);

sub load_plugin {
    my ($self, $args) = @_;
    $args = {module => $args} unless ref $args;
    my $module = $args->{module};
       $module = $self->resolve_plugin($module);
    Mouse::load_class($module);
    my $plugin = $module->new($args->{config} || {});
    $plugin->register( $self );
}

sub resolve_plugin {
    my ( $self, $module ) = @_;
    return ( $module =~ /^\+(.*)$/ ) ? $1 : join '::',
        (
        $self->__trigger_plugin_app_ns,
        $self->__trigger_plugin_ns,
        $module
        );
}

sub register_hook {
    my ($self, @hooks) = @_;
    while (my ($hook, $plugin, $code) = splice @hooks, 0, 3) {
        $self->__hooks->{$hook} ||= [];

        push @{ $self->__hooks->{$hook} }, +{
            plugin => $plugin,
            code   => $code,
        };
    }
}

sub run_hook {
    my ($self, $hook, @args) = @_;
    return unless my $hooks = $self->__hooks->{$hook};
    my @ret;
    for my $hook (@$hooks) {
        my ($code, $plugin) = ($hook->{code}, $hook->{plugin});
        my $ret = $code->( $plugin, @args );
        push @ret, $ret;
    }
    \@ret;
}

sub run_hook_first {
    my ( $self, $point, @args ) = @_;
    croak 'missing hook point' unless $point;

    for my $hook ( @{ $self->__hooks->{$point} } ) {
        if ( my $res = $hook->{code}->( $hook->{plugin}, @args ) ) {
            return $res;
        }
    }
    return;
}

sub run_hook_filter {
    my ( $self, $point, @args ) = @_;
    for my $hook ( @{ $self->__hooks->{$point} } ) {
        @args = $hook->{code}->( $hook->{plugin}, @args );
    }
    return @args;
}

sub get_hook {
    my ($self, $hook) = @_;
    return $self->__hooks->{$hook};
}

1;
__END__

=for stopwords plagger API

=encoding utf8

=head1 NAME

Angelos::Class::Hookable - plagger like plugin feature for Mouse

=head1 SYNOPSIS

    # in main
    my $c = Your::Context->new;
    $c->load_plugin('HTMLFilter::StickyTime');
    $c->load_plugin({module => 'HTMLFilter::DocRoot', config => { root => '/mobirc/' }});
    $c->run();

    package Your::Context;
    use Mouse;
    with 'Angelos::Class::Hookable';

    sub run {
        my $self = shift;
        $self->run_hook('response_filter' => $args);
    }

    package Your::Plugin::HTMLFilter::DocRoot;
    use strict;
    use Angelos::Class::Hookable::Plugin;

    has root => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    hook 'response_filter' => sub {
        my ($self, $context, $args) = @_;
    };

=head1 DESCRIPTION

=head1 METHOD

=over 4

=item $self->load_plugin({ module => $module, config => $conf)

if you write:

    my $app = MyApp->new;
    $app->load_plugin({ module => 'Foo', config => {hoge => 'fuga'})

above code executes follow code:

    my $app = MyApp->new;
    my $plugin = MyApp::Plugin::Foo->new({hoge => 'fuga'});
    $plugin->register( $app );

=item $self->register_hook('hook point', $plugin, $code)

register code to hook point.$plugin is instance of plugin.

=item $self->run_hook('finalize', $c)

run hook.

use case: mostly ;-)

=item $self->run_hook_first('hook point', @args)

run hook.

if your hook code returns true value, stop the hook loop(this feature likes OK/DECLINED of mod_perl handler).

(please look source code :)

use case: handler like mod_perl

=item $self->run_hook_filter('hook point', @args)

run hook.

(please look source code :)

use case: html filter

=item $self->get_hook('hook point')

get the codes.

use case: write tricky code :-(

=back

=head1 TODO

=head1 AUTHOR
Tokuhiro Matsuno E<lt>tokuhirom@gmail.comE<gt>

=head1 SEE ALSO

L<Mouse>, L<Class::Component>, L<Plagger>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

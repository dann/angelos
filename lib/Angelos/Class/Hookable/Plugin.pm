package Angelos::Class::Hookable::Plugin;
use Mouse;
use Scalar::Util ();
use Sub::Exporter;
use Carp ();

{
    my $HOOK_STORE = {};

    my %exports = (
        register => sub {
            sub {
                my ( $self, $c ) = @_;
                my $proto = Scalar::Util::blessed $self or Carp::confess "this is instance method: $self";

                for my $row ( @{ $HOOK_STORE->{$proto} || [] } ) {
                    my ( $hook, $code ) = @$row;
                    $c->register_hook( $hook, $self, $code );
                }
            }
        },
        hook => sub {
            sub {
                my ( $hook, $code ) = @_;
                my $caller = caller(0);
                push @{ $HOOK_STORE->{$caller} }, [ $hook, $code ];
            }
        },
    );

    my $exporter = Sub::Exporter::build_exporter(
        {
            exports => \%exports,
            groups  => { default => [':all'] }
        }
    );

    sub import {
        my $caller = caller();

        strict->import;
        warnings->import;

        return if $caller eq 'main';

        my $meta = Mouse::Meta::Class->initialize($caller);
        $meta->superclasses('Mouse::Object')
            unless $meta->superclasses;

        no strict 'refs';
        no warnings 'redefine';
        *{$caller.'::meta'} = sub { $meta };

        for my $keyword (@Mouse::EXPORT) {
            *{ $caller . '::' . $keyword } = *{'Mouse::' . $keyword};
        }

        goto $exporter;
    }
}

1;
__END__

=head1 NAME

Angelos::Class::Hookable::Plugin - plugin

=head1 SYNOPSIS

    package Your::Plugin::Foo;
    use Angelos::Class::Hookable::Plugin;

=head1 DESCRIPTION

plugin class for Angelos::Class::Hookable.

=head1 METHODS

=over 4

=item register

    $self->register( $c );

internal use only

=item hook

    hook 'hook point' => sub {
        # do something
    };

add coderef to hook point.

=back

=head1 SEE ALSO



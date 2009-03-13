package Angelos::Config::Loader;
use strict;
use warnings;
use Storable;
use Angelos::Config::Validator;
use Angelos::Exceptions;
use Data::Visitor::Callback;
use Angelos::Utils;
use Angelos::Registrar;

sub load {
    my ( $class, $stuff, $schema ) = @_;
    my $config = $class->_make_config($stuff);
    $class->validate_config($config, $schema);
    $class->_substitute_config($config);

    return $config;
}

sub _substitute_config {
    my ( $class, $config ) = @_;

    # Data::Visitor::Callback uses Squirel.
    # Should we depends this module?
    my $v = Data::Visitor::Callback->new(
        plain_value => sub {
            return unless defined $_;
            $class->_config_substitutions($_);
        }
    );
    $v->visit($config);
}

sub validate_config {
    my ($class, $config, $schema) = @_;
    # Angelos::Config::Validator->validate_config( $config, $schema );
}

=head2 _config_substitutions( $value )

This method substitutes macros found with calls to a function. There are three
default macros:

=over 2

=item * C<__HOME__> - replaced with C<Angelos::Utils-E<gt>path_to('')>

=item * C<__path_to(foo/bar)__> - replaced with C<Angelos::Utils-E<gt>path_to('foo/bar')>

=back

=cut

sub _config_substitutions {
    my $class = shift;
    my $subs  = {};
    $subs->{path_to} ||= sub { shift->path_to(@_); };
    my $subsre = join( '|', keys %$subs );
    for (@_) {
        s{__($subsre)(?:\((.+?)\))?__}{ $subs->{ $1 }->( "Angelos::Utils", $2 ? split( /,/, $2 ) : () ) }eg;
    }
}

sub _make_config {
    my ( $class, $stuff ) = @_;
    my $config;
    if ( ref $stuff && ref $stuff eq 'HASH' ) {
        $config = Storable::dclone($stuff);
    }
    else {
        $config = Angelos::Utils::load_yaml($stuff);
    }
    $config;
}

1;

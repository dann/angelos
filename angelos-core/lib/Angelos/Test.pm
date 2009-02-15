package Angelos::Test;
use strict;
use warnings;
 
sub import {
    my $class = shift;
    $class->export_to_level( 1, undef, @_ );
}
 
sub packages_to_import {
    return (
        qw(
Test::Deep
Test::More
Test::Exception
Test::Differences
)
    );
}
 
sub export_to_level {
    my ( $class, $level, $ignore ) = @_;
 
    foreach my $package ( $class->packages_to_import() ) {
        $class->require_dynamic($package);
        my @export;
        if ( $package eq 'Test::Deep' ) {
 
            # Test::Deep exports way too much by default
            @export =
              qw(eq_deeply cmp_deeply cmp_set cmp_bag cmp_methods subbagof superbagof subsetof supersetof superhashof subhashof);
        }
        else {
 
            # Otherwise, grab everything from @EXPORT
            no strict 'refs';
            @export = @{"$package\::EXPORT"};
        }
        $package->export_to_level( $level + 1, undef, @export );
    }
}

sub require_dynamic {
    my ($class, $klazz) = @_;
        eval "require $klazz"; ## no critic (ProhibitStringyEval)
        croak $@ if $@;
}
 
1;

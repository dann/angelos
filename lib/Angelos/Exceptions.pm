package Angelos::Exceptions;
use strict;
use warnings;

use Scalar::Util ();

my %E;

BEGIN {
    %E = (
        'Angelos::Exception' =>
            { description => 'Generic excepction for Angelos' },

        'Angelos::Exception::AbstractMethod' => {
            isa         => 'Angelos::Exception',
            alias       => 'abstract_error',
            description => 'This method is Abstract'
        },

        'Angelos::Exception::UnimplementedMethod' => {
            isa         => 'Angelos::Exception',
            alias       => 'unimplemented_error',
            description => 'This method is unimplemented'
        },

        'Angelos::Exception::DeprecatedMethod' => {
            isa         => 'Angelos::Exception',
            alias       => 'deprecated_error',
            description => 'This method is deprecated'
        },

        'Angelos::Exception::InvalidArgumentError' => {
            isa         => 'Angelos::Exception',
            alias       => 'invalid_argument_error',
            description => 'Argument type mismatch'
        },

        'Angelos::Exception::TemplateNotFound' => {
            isa         => 'Angelos::Exception',
            alias       => 'template_error',
            description => 'Template cannot open template file'
        },

        'Angelos::Exception::FileNotFound' => {
            isa         => 'Angelos::Exception',
            alias       => 'file_not_found_error',
            description => 'file not found error'
        },

        'Angelos::Exception::ParameterMissingError' => {
            isa         => 'Angelos::Exception',
            alias       => 'param_missing_error',
            description => 'parameter is missing'
        },

        'Angelos::Exception::ComponentNotFound' => {
            isa         => 'Angelos::Exception',
            alias       => 'component_not_found_error',
            description => 'Component (MVC) not found'
        },

    );
}

use Exception::Class (%E);

$_->Trace(1) for keys %E;

use base 'Exporter';
our @EXPORT_OK = (
    qw( rethrow_exception virtual_method_error ),
    map { $_->{alias} } grep { exists $_->{alias} } values %E
);

sub rethrow_exception {
    my $e = shift;
    if ( Scalar::Util::blessed($e) and $e->can('rethrow') ) {
        $e->rethrow();
    }
    Angelos::Exception->throw( message => $e );
}

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

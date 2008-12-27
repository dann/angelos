package Angelos::Exceptions;
use strict;
use Angelos::Exception;

# Concrete exceptions
package Angelos::Exception::AbstractMethod;
use base 'Angelos::Exception';
sub description {'This method is abstract'}

package Angelos::Exception::UnimplementedMethod;
use base 'Angelos::Exception';
sub description {'This method is unimplemented'}

package Angelos::Exception::DeprecatedMethod;
use base 'Angelos::Exception';
sub description {'This method is now deprecated'}

package Angelos::Exception::ArgumentTypeError;
use base 'Angelos::Exception';
sub description {'Argument type mismatch'}

package Angelos::Exception::TemplateNotFound;
use base 'Angelos::Exception';
sub description {'Template cannot open template file'}

package Angelos::Exception::DBConnectionError;
use base 'Angelos::Exception';
sub description {'DBI connect error'}

package Angelos::Exception::TemplateParseError;
use base 'Angelos::Exception';
sub description {'TT parse error'}

package Angelos::Exception::LoadingModuleError;
use base 'Angelos::Exception';
sub description {'Error while loading module'}

package Angelos::Exception::ParameterMissingError;
use base 'Angelos::Exception';
sub description {'required parameter is missing'}

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

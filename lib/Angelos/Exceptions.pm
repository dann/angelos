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

package Angelos::Exception::ParamMethodUnimplemented;
use base 'Angelos::Exception';
sub description {'Object does not implement param() method'}

package Angelos::Exception::TemplateNotFound;
use base 'Angelos::Exception';
sub description {'Template cannot open template file'}

package Angelos::Exception::DBConnectionError;
use base 'Angelos::Exception';
sub description {'DBI connect error'}

package Angelos::Exception::TemplateParseError;
use base 'Angelos::Exception';
sub description {'TT parse error'}

package Angelos::Exception::ResourceFileNotFound;
use base 'Angelos::Exception';
sub description {'MessageResource file not found'}

package Angelos::Exception::LoadingModuleError;
use base 'Angelos::Exception';
sub description {'Error while loading module'}

1;

package Angelos::Exception;
use Mouse;
use Error;
extends qw(Error::Simple);

sub description {'Angelos core exception (Abstract)'}

1;

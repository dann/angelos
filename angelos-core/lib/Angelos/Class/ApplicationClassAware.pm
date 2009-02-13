package Angelos::Class::ApplicationClassAware;
use Any::Moose '::Role';
use Angelos::Registrar;

sub app_class {
    ref Angelos::Registrar::context();
}

1;

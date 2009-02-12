package Angelos::Class::ApplicationClassAware;
use Mouse::Role;
use Angelos::Registrar;

sub application_class {
    ref Angelos::Registrar::context();
}

1;

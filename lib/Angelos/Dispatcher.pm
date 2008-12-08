package Angelos::Dispatcher;
use Mouse;
use Angelos::Dispatcher::Dispatch;
extends 'Request::Dispatcher';

sub dispatch_class {
    'Angelos::Dispatcher::Dispatch';
}

__PACKAGE__->meta->make_immutable;

1;

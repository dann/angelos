package TestApp::Web;
use Moose;
use Path::Dispatcher::Rule::Tokens;
use Path::Dispatcher::Rule::Regex;
extends 'Angelos';

__PACKAGE__->meta->make_immutable;

1;

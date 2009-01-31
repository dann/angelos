package Angelos::Middleware::DebugScreen;
use Angelos::Class;
extends 'HTTP::Engine::Middleware::DebugScreen';

has 'powered_by' => (
    +default => sub {
        'Angelos ' . $Angelos::VERSION;
    }
);

__END_OF_CLASS__

package Angelos::PSGI::Engine;
use Mouse;
use Angelos::Types qw( Interface );

has 'interface' => (
    is      => 'ro',
    isa     => Interface,
    handles => [qw(run)],
    coerce   => 1,
);

__PACKAGE__->meta->make_immutable( inline_destructor => 1 );
1;



package Angelos::Debug::MemoryUsage;
use Mouse::Role;

use Devel::MemUsed;
our $memused = Devel::MemUsed->new;

sub reset {
    $memused->reset;
}

sub show {
    print $memused . "\n";
}

1;

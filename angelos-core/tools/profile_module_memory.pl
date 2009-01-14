#!/usr/bin/env perl
use strict;
use warnings;
use Devel::MemUsed;
use Module::Depends;

main();

sub main {
    my $memory_record = record_memory_usage();
}

sub record_memory_usage {
    my $deps = Module::Depends->new->dist_dir('.')->find_modules;
    foreach my $module ( keys %{ $deps->requires } ) {
        my $pid = fork();
        if ($pid) {

            # parent
            wait();
        }
        elsif ( defined $pid ) {
            my $memused = Devel::MemUsed->new;
            eval "use $module";
            print sprintf( "%35s %08d", $module, $memused ) . "\n";
            exit();
        }
        else {
            die "fork error : $!";
        }
    }
}

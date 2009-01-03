#!/bin/sh
rm -f nytprof.out
rm -rf nytprof
perl tools/profile.pl --loop 1000
nytprofhtml -f nytprof.out

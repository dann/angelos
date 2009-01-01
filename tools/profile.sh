#!/bin/sh
rm -f nytprof.out
rm -rf nytprof
perl tools/profile.pl --loop 200
nytprofhtml -f nytprof.out

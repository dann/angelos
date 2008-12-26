#!/bin/sh
rm -f nytprof.out
rm -rf nytprof
perl tools/profile.pl
nytprofhtml -f nytprof.out

#!/bin/sh
perl Makefile.PL
perl tools/module_memory.pl | sort -k 2

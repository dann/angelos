#!/bin/sh
perl tools/memory_leak.pl --loop 1 > memory_leak_1.txt
perl tools/memory_leak.pl --loop 10 > memory_leak_100.txt 
diff -uNr memory_leak_1.txt memory_leak_100.txt
rm -f memory_leak_1.txt
rm -f memory_leak_100.txt

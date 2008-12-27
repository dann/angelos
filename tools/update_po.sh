#!/bin/sh
find {bin,lib} -type f |xargs xgettext.pl -p share/po -o $1.po

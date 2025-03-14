#!/bin/sh
#
# Create grapheme stats for each of the corpus chunk lists
#
for a in t/[cpu]-* ; do
    b=`basename $a`
    echo working on $b
    b/g.sh pcsl $a $b
done

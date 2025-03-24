#!/bin/sh
for a in atu3 atu5 msvo1 msvo4 ; do
    cut -f2 ~/orc/pcsl/newsl/00etc/$a-final.tsv | sort -u >$a.oid
done
cut -f1 ../00etc/easl.tsv | sort -u >easl.oid

    

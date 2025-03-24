#!/bin/sh
for a in atu3 atu5 msvo1 msvo4 ; do
    comm -23 $a.oid easl.oid >$a.not
    grep -f $a.not ~/orc/pcsl/newsl/00etc/$a-final.tsv | cut -f1-3 >$a-not.tsv
done


    

#!/bin/sh
for a in add delete ignore newglyph newglyph remove rename ; do
    grep $a 00etc/tag-actions.tsv | cut -f2 >00etc/do-$a.lst
done

#!/bin/sh
# 00etc/oid-notes.tsv must be kept sorted
cut -f1 00etc/oid-notes.tsv | grep -f - 00etc/easl.tsv | sort \
    | join -t'	' -j 1 - 00etc/oid-notes.tsv | cut -f2,10 >00raw/easl-notes.tsv

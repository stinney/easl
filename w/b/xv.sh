#!/bin/sh
#
# Cross-validate the corpus and the PC25 repertoire
#

# Phase1 reduction of .tok data:
# 	get the KEY TYPE NAMES FORM fields
grep '^g	o' ../00etc/pc25.tok | \
    sed 's,^g\t\(\S\+\)\t\S\+:\(.\)/.*=\(\S\+\)#wn\S\+\t\(\S\+\)$,\1\t\2\t\3\t\4,' \
	>t/xv-tok-1.tsv

# Phase2 reduction of Phase1 data:
#	reduce o0900728.o0900729. to o0900729. and remove . and .. from KEY
sed 's/^o[0-9]\{7\}\.o/o/' <t/xv-tok-1.tsv | sed 's/\.\+\t/\t/' >t/xv-tok-2.tsv

# Phase3 reduction of Phase2 data:
#	reduce GAL-GAL~a- to GAL~a and remove -\t
sed 's/-\+\t/\t/' <t/xv-tok-2.tsv | \
    sed 's/\t\(\S\+\)-\(\S\+\)\t/\t\2\t/' | \
    sort >t/xv-tok-3.tsv

# Add counts to reduced tok data
uniq -c t/xv-tok-3.tsv | sed 's/^\s\+\([0-9]\+\)\s\(.*\)$/\2\t\1/' >t/corpus.tsv

# Add sort codes
sort -k1 /home/oracc/pcsl/02pub/sortcodes.tsv | \
    join -t'	' -j 1 t/corpus.tsv - \
	 >t/corpus-s.tsv

# List signs not in repertoire
cut -f1 rep-pc25.txt | sort -u >t/rep
cut -f1 t/corpus-s.tsv | sort -u >t/crp
comm -23 t/crp t/rep >t/not
comm -23 t/not rep-not.txt >t/bad
grep -f t/bad t/corpus-s.tsv | grep -v '	n	' >t/rep-miss.tsv
cut -f1 t/rep-miss.tsv >rep-miss.txt

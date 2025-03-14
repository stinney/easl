##!/bin/sh

p=$1
l=$2
b=$3

if [ "$p" = "" ] || [ "$l" = "" ] || [ "$b" = "" ]; then
    echo $0: Must give PROJECT LIST BASE on command line. Stop.
    exit 1
fi

ph=`/bin/echo -n $p | tr / -`
pt=t/$ph.tok

# Phase0 reduction of .tok data:
#	extract data for texts in list

# Don't extract from main .tok for every list
if [ ! -r $pt ]; then
    b/gp.sh $p >$pt
fi

# Force the list to be in the best format
cut -d: -f2 $l | sed 's/^\(.\+\)$/^\1	/' >t/$b.grep

# Subset the list ready for Phase1
grep -f t/$b.grep $pt | cut -f2- >t/gl-$b.tok

# Phase1 reduction of .tok data:
# 	get the KEY TYPE NAMES FORM fields
grep '^g	o' t/gl-$b.tok | \
    sed 's,^g\t\(\S\+\)\t\S\+:\(.\)/.*=\(\S\+\)#wn\S\+\t\(\S\+\)$,\1\t\2\t\3\t\4,' \
	>t/g-$b-1.tsv

# Phase2 reduction of Phase1 data:
#	reduce o0900728.o0900729. to o0900729. and remove . and .. from KEY
sed 's/^o[0-9]\{7\}\.o/o/' <t/g-$b-1.tsv | sed 's/\.\+\t/\t/' >t/g-$b-2.tsv

# Phase3 reduction of Phase2 data:
#	reduce GAL-GAL~a- to GAL~a and remove -\t
sed 's/-\+\t/\t/' <t/g-$b-2.tsv | \
    sed 's/\t\(\S\+\)-\(\S\+\)\t/\t\2\t/' | \
    sort >t/g-$b-3.tsv

# Add counts to reduced tok data
uniq -c t/g-$b-3.tsv | sed 's/^\s\+\([0-9]\+\)\s\(.*\)$/\2\t\1/' >t/g-$b.tsv

# Add sort codes
sort -k1 /home/oracc/pcsl/02pub/sortcodes.tsv | \
    join -t'	' -j 1 t/g-$b.tsv - \
	 >t/g-$b-s.tsv

# Write data count of n and non-n distinct-signs/total-instances
echo `grep -c '	n	' t/g-$b.tsv`/`grep -c '	n	' t/g-$b-3.tsv` >t/g-$b-n.cnt
echo `grep -vc '	n	' t/g-$b.tsv`/`grep -vc '	n	' t/g-$b-3.tsv` >t/g-$b-i.cnt

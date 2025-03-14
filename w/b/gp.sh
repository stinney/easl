#!/bin/sh
#
# Add the PQX number to each g-line of a .tok file and output only
# those lines.
#
p=$1

if [ "$p" = "" ]; then
    echo $0: Must give project on command line. Stop.
    exit 1
fi

t=/home/oracc/$p/02pub/csl.tok
grep ^[Tg] $t | grep -vF '	..	' | while IFS= read l ; do
    if [[ "$l" == "T"* ]]; then
	P=`/bin/echo -n $l | cut -d' ' -f3`
    else
	echo $P'	'"$l"
    fi
done

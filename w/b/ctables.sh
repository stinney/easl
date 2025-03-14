#!/bin/sh
V="uruk jn umma uqair misc"
cd t
h=corpus.tsv
# table by period/place/pub-unpub
echo '	IV/pub	IV/unp	IV/all	III/pub	III/unp	III/all' >$h
for a in $V ; do
    if [ $a = "uruk" ]; then
	b=Uruk
    elif [ $a = "umma" ]; then
	b=Umma
    elif [ $a = "uqair" ]; then
	b=Uqair
    elif [ $a = "jn" ]; then
	b=JN
    else
	b=Misc
    fi
    echo $b'	'`../b/l c-4-$a-p`'	'`../b/l c-4-$a-u`'	'`../b/l c-4-$a` \
	 '	'`../b/l c-3-$a-p`'	'`../b/l c-3-$a-u`'	'`../b/l c-3-$a`  >>$h
done
echo total'	'`../b/l p-4`'	'`../b/l u-4`'	'`../b/l c-4` \
     '	'`../b/l p-3` '	'`../b/l u-3`'	'`../b/l c-3`  >>$h

rocox -h <$h | xl - >corpus.html
cd ..

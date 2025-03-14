#!/bin/sh
V="uruk jn umma uqair misc"
cd t
h=gstats.tsv
# grapheme stats by period/place/pub-unpub
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
    echo $b/num'	'`cat g-c-4-$a-p-n.cnt`'	'`cat g-c-4-$a-u-n.cnt`'	'`cat g-c-4-$a-n.cnt` \
	 '	'`cat g-c-3-$a-p-n.cnt`'	'`cat g-c-3-$a-u-n.cnt`'	'`cat g-c-3-$a-n.cnt`  >>$h
    echo $b/idg'	'`cat g-c-4-$a-p-i.cnt`'	'`cat g-c-4-$a-u-i.cnt`'	'`cat g-c-4-$a-i.cnt` \
	 '	'`cat g-c-3-$a-p-i.cnt`'	'`cat g-c-3-$a-u-i.cnt`'	'`cat g-c-3-$a-i.cnt`  >>$h
done
echo total'	'`cat g-p-4-n.cnt`'	'`cat g-u-4-n.cnt`'	'`cat g-c-4-n.cnt` \
     '	'`cat g-p-3-n.cnt` '	'`cat g-u-3-n.cnt`'	'`cat g-c-3-n.cnt`  >>$h
echo total'	'`cat g-p-4-i.cnt`'	'`cat g-u-4-i.cnt`'	'`cat g-c-4-i.cnt` \
     '	'`cat g-p-3-i.cnt` '	'`cat g-u-3-i.cnt`'	'`cat g-c-3-i.cnt`  >>$h

rocox -h <$h | xl - >gstats.html

cd ..

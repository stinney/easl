#!/bin/sh
qx="qx -j pcsl/pc25 -i cat"
p=period
v=provenience
V="uruk umma uqair jn misc"
c="cut -d: -f2"

rm -f t/[cgpux]-* t/gl-*.tok

$qx $p='uruk iii' | $c | sort >t/c-3
$qx $p='uruk iv'  | $c | sort >t/c-4
sort t/c-[34] >t/c
$qx $p='uruk iii' | xmdfields.plx >t/x-3
$qx $p='uruk iv'  | xmdfields.plx >t/x-4

for a in Warka Jokha Jemdet Uqair ; do
    if [ "$a" = "Warka" ]; then
	b=uruk
    elif [ "$a" = "Jokha" ]; then
	b=umma
    elif [ "$a" = "Uqair" ]; then
	b=uqair
    else
	b=jn
    fi
    grep $a t/x-3 | cut -f1 | sort >t/c-3-$b
    grep $a t/x-4 | cut -f1 | sort >t/c-4-$b
done

# compute misc texts
sort -u t/c-3-* | comm -23 t/c-3 - >t/c-3-misc
sort -u t/c-4-* | comm -23 t/c-4 - >t/c-4-misc

cut -f1,7,11 ~/orc/pcsl/00cat/uruk-iv-iii.tsv | grep unpublished | grep III$ | cut -f1 | sort >t/u-3
cut -f1,7,11 ~/orc/pcsl/00cat/uruk-iv-iii.tsv | grep unpublished | grep IV$ | cut -f1 | sort >t/u-4

# compute published texts
comm -23 t/c-3 t/u-3 >t/p-3
comm -23 t/c-4 t/u-4 >t/p-4

# compute published/unpublished texts for each provenience
for a in $V ; do
    comm -12 t/c-3-$a t/u-3 >t/c-3-$a-u
    comm -12 t/c-3-$a t/p-3 >t/c-3-$a-p
    comm -12 t/c-4-$a t/u-4 >t/c-4-$a-u
    comm -12 t/c-4-$a t/p-4 >t/c-4-$a-p
done

(cd t ; ls -1 c-* | sort >../../../00lib/toklists.lst)
mkdir -p ../../00lib/lists
for a in t/c-* ; do
    sed 's/^/pcsl:/' <$a >../../00lib/lists/`basename $a`
done


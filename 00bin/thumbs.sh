#!/bin/sh
rm -fr thumb
mkdir -p thumb
for a in ghjpg/*.jpg ; do
    convert -thumbnail '40%' $a thumb/`basename $a`
done
cp xthumb/* thumb

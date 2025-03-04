#!/bin/sh
rm -fr thmbs1
mkdir -p thmbs1
for a in ghjpg/*.jpg ; do
    convert -density 400 -thumbnail '40%' $a thumb/`basename $a .jpg`.png
done
cp xthumb/* thumb

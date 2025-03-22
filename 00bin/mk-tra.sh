#!/bin/sh
#!/bin/sh
rm -fr tra
mkdir -p tra
for a in thm/*.png ; do
    convert $a -fuzz '3%' -transparent white tra/`basename $a`
done

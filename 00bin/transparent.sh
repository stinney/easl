#!/bin/sh
#!/bin/sh
rm -fr trans
mkdir -p trans
for a in thumb/*.png ; do
    convert $a -fuzz '3%' -transparent white trans/`basename $a`
done

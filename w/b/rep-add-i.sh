#!/bin/sh
#
# Bespoke filter to produce rep-add-i.xml from rep-add.tsv
#
cat rep-add.tsv | \
    rocox -e -x oids -R'<oid xml:id="%1"><td>%5</td><td>%2</td><td>%3</td><td><esp:image file="add/%4" description="%2"/></td></oid>' \
	  >rep-add-i.xml

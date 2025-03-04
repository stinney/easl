SL=easl
SLfont=PC-all.ttf
WWW=/home/oracc/www/${SL}

default: easl frame codes salts names notes tags images oids rows font html

easl: 00etc/easl.tsv

frame: 00raw/${SL}-frame.lst

codes: 00raw/${SL}-codes.tsv

salts: 00raw/${SL}-salts.log

names: 00raw/${SL}-names.tsv

notes: 00raw/${SL}-notes.tsv

tags: 00raw/${SL}-tags.tsv

images:
	00bin/images.sh

oids: 00raw/${SL}-oids.tsv

rows: 00raw/${SL}-rows.tsv

font: /home/oracc/www/fonts/${SLfont}

00etc/easl.tsv: 00etc/gh-index.xml 00bin/gh-cpc-tsv.xsl 00bin/easl-*.plx
	xsltproc 00bin/gh-cpc-tsv.xsl 00etc/gh-index.xml >01tmp/easl-gh.tsv
	00bin/easl-oid.plx >01tmp/easl-oid.tsv
	00bin/easl-sort.plx 01tmp/easl-oid.tsv >01tmp/easl-sort.tsv
	00bin/easl-number.plx 01tmp/easl-sort.tsv >01tmp/easl-numbered.tsv
	00bin/easl-codes.plx >00etc/easl.tsv

/home/oracc/www/fonts/${SLfont}: ~/o2/msc/fonts/${SLfont}
	sudo cp $< $@
	sudo chmod o+r $@

00raw/easl-frame.lst: 00etc/${SL}.tsv
	cut -f 2 $< >$@

00raw/easl-names.tsv: 00etc/${SL}.tsv Makefile
	00bin/easl-names.plx >$@

00raw/easl-codes.tsv: 00etc/${SL}.tsv
	cut -f 2,8 $< >$@

00raw/easl-salts.log: 00etc/nc-cdli.tsv 00raw/easl-frame.lst
	00bin/easl-salts.plx >$@

00raw/easl-oids.tsv: 00etc/${SL}.tsv Makefile
	cut -f 1,2 $< | rocox -C21 >$@

00raw/easl-rows.tsv: 00etc/${SL}.tsv Makefile
	cut -f 1,2 $< | sed "s#^\(o[0-9]\+\)#/easl/images/\1.png#" | rocox -C21 >$@

00raw/easl-tags.tsv: 00etc/${SL}-tags.tsv Makefile
	grep -v '^##' 00etc/${SL}-tags.tsv | cut -f1,3 | rocox -C21 | grep -v '	$$' >$@

00raw/easl-notes.tsv: 00etc/oid-notes.tsv 00bin/easl-notes.sh 00etc/easl.tsv
	00bin/easl-notes.sh

html: 00web/sltab.html

00web/sltab.html: 00raw/* 00bin/* Makefile
	mkdir -p 00web
	sudo mkdir -p ${WWW}/css
	sudo cp 00res/css/*.css ${WWW}/css/
	00bin/h.sh
	sudo cp 00web/sltab*.html ${WWW}
	sudo chmod -R +r ${WWW} /home/oracc/www/fonts

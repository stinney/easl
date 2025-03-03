SL=easl
SLfont=PC-all.ttf
WWW=/home/oracc/www/${SL}

default: easl frame names codes notes images rows font html

easl: 00etc/easl.tsv

frame: 00raw/${SL}-frame.lst

names: 00raw/${SL}-names.tsv

codes: 00raw/${SL}-codes.tsv

notes: 00raw/${SL}-notes.tsv

images:
	00bin/images.sh

font: /home/oracc/www/fonts/${SLfont}

rows: 00raw/${SL}-rows.tsv

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
	cut -f 3,8 $< | rocox -C21 >$@

00raw/easl-codes.tsv: 00etc/${SL}.tsv
	cut -f 2,8 $< >$@

00raw/easl-rows.tsv: 00etc/${SL}.tsv Makefile
	cut -f 1,2 $< | sed "s#^\(o[0-9]\+\)#/easl/images/\1.jpg#" | rocox -C21 >$@

00raw/easl-notes.tsv: 00etc/oid-notes.tsv 00bin/easl-notes.sh 00etc/easl.tsv
	00bin/easl-notes.sh

html: 00web/sltab.html

00web/sltab.html: 00raw/* 00bin/* Makefile
	mkdir -p 00web
	sudo mkdir -p ${WWW}/css
	sudo cp 00res/css/*.css ${WWW}/css/
	00bin/h.sh
	sudo cp 00web/sltab.html ${WWW}
	sudo chmod -R +r ${WWW} /home/oracc/www/fonts

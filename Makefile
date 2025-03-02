SL=easl
SLfont=PC-all.ttf
WWW=/home/oracc/www/${SL}

default: frame names codes images rows font html

frame: 00raw/${SL}-frame.lst

names: 00raw/${SL}-names.tsv

codes: 00raw/${SL}-codes.tsv

images:
	00bin/images.sh

font: /home/oracc/www/fonts/${SLfont}

/home/oracc/www/fonts/${SLfont}: ~/o2/msc/fonts/${SLfont}
	sudo cp $< $@
	sudo chmod o+r $@

rows: 00raw/${SL}-rows.tsv

00raw/easl-frame.lst: 00etc/${SL}.tsv
	cut -f 3 $< >$@

00raw/easl-names.tsv: 00etc/${SL}.tsv Makefile
	cut -f 2,8 $< | rocox -C21 >$@

00raw/easl-codes.tsv: 00etc/${SL}.tsv
	cut -f 3,8 $< >$@

00raw/easl-rows.tsv: 00etc/${SL}.tsv Makefile
	cut -f 1,3 $< | sed "s#^\(o[0-9]\+\)#/easl/images/\1.jpg#" | rocox -C21 >$@

html: 00web/sltab.html

00web/sltab.html: 00raw/* 00bin/* Makefile
	mkdir -p 00web
	sudo mkdir -p ${WWW}/css
	sudo cp 00res/css/*.css ${WWW}/css/
	00bin/h.sh
	sudo cp 00web/sltab.html ${WWW}
	sudo chmod -R +r ${WWW} /home/oracc/www/fonts

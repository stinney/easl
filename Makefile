SL=easl
SLfont=PC-all.ttf

default: frame codes images rows font html

frame: 00raw/${SL}-frame.tsv

codes: 00raw/${SL}-codes.tsv

images:
	00bin/images.sh

font: /home/oracc/www/fonts/${SLfont}

/home/oracc/www/fonts/${SLfont}: ~/o2/msc/fonts/${SLfont}
	sudo cp $< $@
	sudo chmod o+r $@

rows: 00raw/${SL}-rows.tsv

00raw/easl-frame.tsv: 00etc/${SL}.tsv
	cut -f 3 $< >$@

00raw/easl-codes.tsv: 00etc/${SL}.tsv
	cut -f 3,8 $< >$@

00raw/easl-rows.tsv: 00etc/${SL}.tsv
	cut -f 1,3 $< | sed "s#^\(o[0-9]\+\)#/easl/images/thumb/\1.jpg#" | rocox -C21 >$@

html: 00web/sltab.html

00web/sltab.html: 00raw/*
	sudo cp 00res/css/*.css /home/oracc/www/$SL/css/
	00bin/h.sh
	cp 00web/sltab.html /home/oracc/www/easl
	sudo chmod -R +r /home/oracc/www/edur /home/oracc/www/fonts

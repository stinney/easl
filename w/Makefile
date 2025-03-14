default: pc25

# t/pcsl.tok
# b/gx.sh
# b/csltab.sh

pc25:
	mkdir -p t w
	b/newrep.sh
	b/corpus.sh
	make xml
	make web
	rm -fr ../00web/pepc
	mv w ../00web/pepc

#	b/xv.sh # xv is done differently in ../00bin/xv.sh and there will be no need for it in production pages

pos=b/pos.sh $(@F) pcsl > $@

xml: w/rep-pc25.xml

xxml: w/pc25-nc+v.xml w/pc25-nc-v.xml w/pc25-tc-idg.xml \
	w/rm-broken.xml w/rm-nc-singletons.xml w/rm-seq.xml w/rm-nc-heads.xml  \
	w/rm-opaque.xml w/rm-unattest.xml \
	w/pc25-ncv-editme.xml w/rep-num.xml w/rep-add.xml w/rep-city.xml \
	w/rep-pc25.xml w/rep-miss.xml w/rep-not.xml

w/pc25-nc+v.xml: pc25-nc+v.xml pc25-nc+v.txt b/pos.sh
	$(pos)

w/pc25-nc-v.xml: pc25-nc-v.xml pc25-nc-v-i.xml b/pos.sh
	$(pos)

pc25-nc-v-i.xml: pc25-nc-v.tsv
	cut -f3,5 pc25-nc-v.tsv | b/oid-notes.sh >$@

ncv-new-i.xml: ncv-new.tsv b/oid-notes.sh
	cut -f1,3 ncv-new.tsv | b/oid-notes.sh >$@

w/pc25-tc-idg.xml: pc25-tc-idg.xml pc25-tc-idg-i.xml b/pos.sh
	$(pos)

w/rm-broken.xml: rm-broken.txt b/pos.sh
	$(pos)

w/rm-opaque.xml: rm-opaque.txt b/pos.sh
	$(pos)

w/rm-seq.xml: rm-seq.txt b/pos.sh
	$(pos)

%-i.xml: %.tsv
	cat $? | b/oid-notes.sh >$@

w/rm-nc-singletons.xml: rm-nc-singletons-i.xml b/pos.sh
	$(pos)

w/rm-nc-heads.xml: rm-nc-heads-i.xml b/pos.sh
	$(pos)

w/rm-unattest.xml: rm-unattest-i.xml b/pos.sh
	$(pos)

# destined to be renamed as rep-ncv
w/pc25-ncv-editme.xml: ncv-new-i.xml b/pos.sh
	$(pos)

w/rep-num.xml: rep-num.txt b/pos.sh
	$(pos)

w/rep-city.xml: rep-city.txt b/pos.sh
	$(pos)

w/rep-add.xml: rep-add-i.xml b/pos.sh
	$(pos)

rep-add-i.xml: rep-add.tsv b/rep-add-i.sh
	b/rep-add-i.sh

w/rep-pc25.xml: rep-pc25.txt b/pos.sh
	$(pos)

w/rep-miss.xml: rep-miss.txt b/pos.sh
	$(pos)

w/rep-not.xml: rep-not.txt b/pos.sh
	$(pos)

web: w/pc25.xml w/introduction.xml w/corpus.xml w/analysis.xml \
	w/principles.xml w/signlists.xml w/approaches.xml w/font.xml \
	w/numbers.xml w/repertoire.xml w/removals.xml w/numbers.xml

# w/ap24qa.xml

w/%.xml: x/%.xml
	cp $? $@

clean:
	rm *-i.xml

wclean: clean
	rm -fr w

t/pcsl.tok: /home/oracc/pcsl/02pub/csl.tok
	b/gp.sh pcsl >$@


easl: 00etc/easl-final.tsv

00etc/easl-final.tsv: 00etc/easl-base.tsv 00bin/sl-number.plx
	00bin/sl-number.plx -1 -n EASL0001 <$< >$@

clean:
	rm -f 00etc/easl-final.tsv 00etc/easl-final.xml

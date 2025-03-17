.PRECIOUS: pepc.log

default: pepc.pdf

pepc.pdf: st.tex pepc.tex
	oracctex pepc

st.tex: st.xml /home/oracc/lib/scripts/html2tex.xsl /home/oracc/bin/html2tex.sh
	html2tex.sh st

st.xml: /home/oracc/pcsl/pepc/01tmp/source-tree-40.xml
	xl $< >$@

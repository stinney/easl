default: pepc.pdf

pepc.pdf: st.tex pepc.tex
	oracctex pepc

st.tex: st.xml
	html2tex.sh st

st.xml: /home/oracc/pcsl/pepc/01tmp/source-tree-40.xml
	xl $< >$@

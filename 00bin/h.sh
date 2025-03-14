#!/bin/sh
mkdir -p 00web/easl
(cd 00raw ;
 ../00bin/slframe.plx easl-frame.lst >f.xml ;
 xsltproc ../00bin/slframe-HTML.xsl f.xml >../00web/easl/sltab.xml
 xsltproc -stringparam mode NC ../00bin/slframe-HTML.xsl f.xml >../00web/easl/sltab-nc.xml
 xsltproc -stringparam mode SQ ../00bin/slframe-HTML.xsl f.xml >../00web/easl/sltab-sq.xml
)

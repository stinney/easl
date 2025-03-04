#!/bin/sh
(cd 00raw ;
 ../00bin/slframe.plx easl-frame.lst >f.xml ;
 xsltproc ../00bin/slframe-HTML.xsl f.xml >../00web/sltab.html
 xsltproc -stringparam mode NC ../00bin/slframe-HTML.xsl f.xml >../00web/sltab-nc.html
 xsltproc -stringparam mode SQ ../00bin/slframe-HTML.xsl f.xml >../00web/sltab-sq.html
)

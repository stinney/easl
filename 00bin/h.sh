#!/bin/sh
(cd 00raw ;
 ../00bin/slframe.plx easl-frame.lst >f.xml ;
 xsltproc ../00bin/slframe-HTML.xsl f.xml >../00web/sltab.html
 xsltproc -stringparam mode nc ../00bin/slframe-HTML.xsl f.xml >../00web/sltab-nc.html
)

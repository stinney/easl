#!/bin/sh
(cd 00raw ;
 ../00bin/slframe.plx easl-frame.lst | xsltproc ../00bin/slframe-HTML.xsl - >../00web/sltab.html
)


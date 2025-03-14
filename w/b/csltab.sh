#!/bin/sh
b/csltab.plx >t/csltab.xml 2>t/csltab.log
xsltproc b/csltab.xsl t/csltab.xml >x/csltab.xml

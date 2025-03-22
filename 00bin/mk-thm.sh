#!/bin/sh
rm -fr thm ; mkdir thm
(cd svg ; for a in *.svg ; do convert $a -scale '40%' ../thm/`basename $a .svg`.png ; done)

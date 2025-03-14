#!/bin/sh
#
# Apply the page-o-signs process to arg 1 in project arg 2
#
xmllint --encode UTF-8 --xinclude --noxincludenode $1 | \
     xsltproc -stringparam project $2 \
              ${ORACC}/lib/scripts/sxweb-page-o-signs.xsl -

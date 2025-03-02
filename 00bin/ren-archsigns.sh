#!/bin/sh
rm -fr ghjpg ; mkdir ghjpg
cat oid-easl.tsv | rocox -n -R'cp "../proto-cuneiform_signs/%6" ghjpg/%1.jpg' >cp.sh

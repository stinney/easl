#!/bin/sh
rm -fr ghjpg ; mkdir ghjpg
rocox -n -R"cp '../proto-cuneiform_signs/%6' ghjpg/%1.jpg" <oid-easl.tsv |
    /bin/sh -s


#!/bin/sh
00bin/easl-oid.plx >01tmp/easl-oid.tsv
00bin/addcodes.plx >01tmp/easl.tsv 2>nocodes.log

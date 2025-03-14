#!/bin/sh
#
# Filter to turn two column OID/NOTES into XML format for POS system
#
rocox -x oids -R'<oid xml:id="%1"><td class="notes">%2</td></oid>'

#!/bin/sh
if [ -d orig ]; then
    (cd orig ;
     for a in *.png ; do
	 convert $a -fuzz 1% -trim +repage PNG8:../$a
     done
     )
else
    echo $0: no orig/ directory. Stop.
    exit 1
fi

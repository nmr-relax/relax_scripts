#!/bin/tcsh -e

set FTS=`ls -v -d -1 */*.ft2`

foreach FT ($FTS)
    set DNAME=`dirname $FT`
    set BNAME=`basename $FT`
    set FNAME=`echo $BNAME | cut -d'.' -f1`
    echo $FT $DNAME $BNAME $FNAME
    pipe2ucsf $FT ${DNAME}/${FNAME}.ucsf
end

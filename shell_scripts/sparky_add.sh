#!/bin/tcsh -e

if ($#argv < 4) then
    echo "Change value of column"
    echo "Usage: $0 file" "'"'$X'"'" "'"'0.1'"' peaks_out.list "
    echo "sparky_add.sh sparky.list" "'"'$2'"'" "-0.132 peaks_out.list"
    goto done
endif

set PEAKS=$1
set PEAKSTEMP=${PEAKS}.temp
set COL=$2
set COLOFFSET=$3
set PEAKSOUT=$4
set LINE='$0'

awk '$2 ~ /^[0-9]/{print $0}' $PEAKS > $PEAKSTEMP
awk "{ ${COL} = ${COL} + $COLOFFSET; print $LINE } " $PEAKSTEMP > $PEAKSOUT
rm $PEAKSTEMP

done: ; exit 0


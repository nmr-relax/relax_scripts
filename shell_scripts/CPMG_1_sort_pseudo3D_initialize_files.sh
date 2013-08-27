#!/bin/bash -e

if [ -f fid ]; then
    echo "File exist: fid"
    IN=fid
else
    echo "FID file not found in current folder"
    exit $?
fi

if [ -f procpar ]; then
PLANE=`awk '/^ncyc /{f=1;next}f{print $1;exit}' procpar`
echo "Number of ncyc/planes in procpar: $PLANE"
MODEPAR=`awk '/^array /{f=1;next}f{print $2;exit}' procpar`
IFS=',' read -a MODEARR <<< "$MODEPAR"
echo "Modearray is: $MODEARR"
if [ ${MODEARR[0]} == '"phase' ]; then
MODE=1
fi
if [ ${MODEARR[0]} == '"ncyc' ]; then
MODE=0
fi
echo "Array is recorded: $MODEPAR, so mode should be: $MODE"
NI=`awk '/^ni /{f=1;next}f{print $2;exit}' procpar`
echo "Found in the file procpar that ni=$NI"
NP=`awk '/^np /{f=1;next}f{print $2;exit}' procpar`
echo "Found in the file procpar that np=$NP"
fi

echo 
echo "I suggest following sort_psedo3D command, which I will do for you"
echo "####################"
echo "sort_pseudo3D -in $IN -plane $PLANE -mode $MODE -ni $NI -np $NP"
echo "####################"
sort_pseudo3D -in $IN -plane $PLANE -mode $MODE -ni $NI -np $NP
echo 
echo "I moved your 'fid' to 'fid_original_interleaved"
echo "And made a link from 0.fid to fid, to use in varian"
echo 
echo "Now just click, 'read parameters', check 'Rance-Kay'"
echo "Remember to set Y-'Observe Freq MHz' to N15"
echo "Click 'Save script' to make 'fid.com' file, and 'Quit', and run the next CPMG script"

mv -n fid fid_original_interleaved
ln -s 0.fid fid
varian
rm fid
ln -s fid_original_interleaved fid

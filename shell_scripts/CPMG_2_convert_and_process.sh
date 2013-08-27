#!/bin/bash

PLANE="ERR"
if [ -f procpar ]; then
PLANE=`awk '/^ncyc /{f=1;next}f{print $1;exit}' procpar`
PLANE=$(($PLANE -1))
#echo $PLANE
fi

if [ -f fid.com ]; then
  if grep -Fq "sleep" fid.com; then
  echo "sleep found in fid.com and is removed"
  sed -i '/^sleep/d' fid.com
  fi
  if grep -Fq "var2pipe -in ./0.fid" fid.com; then
  echo "0.fid found in fid.com and changed to 'fid'"
  sed -i "s/0.fid/fid/g" fid.com
  fi
fi

if [ ! -f convert_all.com ]; then
echo "'convert_all.com' does not exist, I will copy it over, alter it, and run it"
cp ./../scripts/convert_all.com $PWD
  if [ $PLANE != "ERR" ]; then
  sed -i "s/x <= 35/x <= $PLANE/g" convert_all.com
  fi
fi

echo 
echo "I suggest run convert_all.com, which I will do for you"
echo "####################"
echo "csh convert_all.com"
echo "####################"
tcsh convert_all.com
echo "Now we need to transform the spectra."
echo "Process one of the files normally and copy the processing script to the experiment folder."
echo "[m]->Right-Click Process 2D->Basic 2D"
echo "Save->Execute->Done; then; RClick File->Select File->test.ft2->Read/draw->Done"
echo "If your spectra look reversed (i.e. if your peaks do not seem to match your reference spectrum) it might be solved by changing to"
echo "[m] '| nmrPipe -fn FT -neg \' to the script to the third lowest line."
echo "Save->Execute->Done. Then push [r] to refresh."
echo "Press [h], and find P0 and P1, and push [m], change parameters and update script"
echo "The changes to '| nmrPipe  -fn PS xxx \' should be the FIRST line (The proton dimension) with PS"
echo "save/execute, push [r] (read) and the [e] (erase settings) to see result in NMRdraw"
echo "And then run the next CPMG script"
cd 0.fid
nmrDraw
cp nmrproc.com ../fft.com
cd ..


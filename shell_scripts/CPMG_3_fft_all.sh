#!/bin/bash -e

PLANE="ERR"
if [ -f procpar ]; then
PLANE=`awk '/^ncyc /{f=1;next}f{print $1;exit}' procpar`
PLANE=$(($PLANE -1))
#echo $PLANE
fi

if [ -f fft.com ]; then
  echo "fft.com in your folder"
else
echo "no fft.com in your folder"
  if [ -f 0.fid/fft.com ]; then
  echo "fft.com in your 0 folder, and copy it to here"
  cp 0.fid/fft.com .
  elif [ -f 0.fid/nmrproc.com ]; then
  echo "nmrproc.com in your 0 folder, and copy it to here as fft.com"
  cp 0.fid/nmrproc.com ./fft.com
  else
  exit
  fi
fi

if [ ! -f fft_all.com ]; then
echo "'fft_all.com' does not exist, I will copy it over, alter it, and run it"
cp ./../scripts/fft_all.com $PWD
  if [ $PLANE != "ERR" ]; then
  sed -i "s/x <= 35/x <= $PLANE/g" fft_all.com
  sed -i '/^$/d' fft_all.com
  fi
fi

echo 
echo "I suggest run fft_all.com, which I will do for you"
echo "####################"
echo "csh fft_all.com"
echo "####################"
csh fft_all.com
echo
echo "Now get a peak list"
echo "In CCPNMR Analysis, you open one of you spectra from the relaxation series."
echo "Assign all the peaks you want to analyse. Usually, this is done by copying a peaklist from a HSQC experiment"
echo "and adjusting the crosses so they lie exactly on top of the peaks."
echo "It is important to remove all unassigned peaks from the peak list."
echo "If your spectrum is folded, pick the peaks at their position in the folded spectrum."
echo "Export this peak list in to you data folder as Sparky peak list using FormatConverter. (Other>FormatConverter and export>Sparky)"
echo "In analysis: Other->Format Converter->Export->Sparky->Peaks export menu->Select peak list->Select export file->"
echo "Save it for example as: 'peaks_20121005.sparky' in your experiment folder"



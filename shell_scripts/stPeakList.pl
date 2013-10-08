#! /usr/bin/perl
 
# Creates a peak list for seriesTab given a 
# nmrPipe spektrum and a Sparky peak list
#
# usage: stPeakList [pipe spectrum] [Sparky peak list]
#
# Kaare Teilum 061025
# Modified 131008 by Troels E. Linnet

$pipeFile = $ARGV[0];
$sparkyList = $ARGV[1];
 
open HDR, "showhdr $pipeFile |" or die "can't run: showhdr $pipeFile";
while (<HDR>){
        if (/OBS MHz/){
                /([0-9]+\.[0-9]+)\s+([0-9]+\.[0-9]+)/;
                $frqX=$1;
                $frqY=$2;
        };
        if (/DATA SIZE/){
                /([0-9]+)\s+([0-9]+)/;
                $sizeX=$1;
                $sizeY=$2;
        };
        if (/ORIG Hz/){
                /(-*[0-9]+\.[0-9]+)\s+(-*[0-9]+\.[0-9]+)/;
                $origX=$1;
                $origY=$2;
        };
        if (/SW Hz/){
                /([0-9]+\.[0-9]+)\s+([0-9]+\.[0-9]+)/;
                $swX=$1;
                $swY=$2;
        };
};
close(HDR);
 
$stepX=$swX/$frqX/$sizeX;
$highX=($origX+$swX)/$frqX;
$highX2SW=($origX+2*$swX)/$frqX;
$stepY=$swY/$frqY/$sizeY;
$highY=($origY+$swY)/$frqY;
$highY2SW=($origY+2*$swY)/$frqY;
$i=1;
print "VARS   INDEX X_AXIS Y_AXIS X_PPM Y_PPM VOL ASS X1 X3 Y1 Y3\n";
print "FORMAT %5d %9.3f %9.3f %8.3f %8.3f %+e %s %4d %4d %4d %4d\n\n";
 
open IN, "$sparkyList" or die "Cannot open $sparkyList for read";
        while (<IN>){
                @process = split (/\s+/, $_);
                if ($process[0] eq ""){splice (@process, 0, 1)};
                if ($process[0] ne "Assignment" && $process[0] ne ""){
                        $ptsX=($highX-$process[2])/$stepX;
                        if ($ptsX < 0){
                        $ptsX=($highX2SW-$process[2])/$stepX;
                        }
                        $ptsX_X1=$ptsX-1;
                        $ptsX_X3=$ptsX+1;
                        $ptsY=($highY-$process[1])/$stepY;
                        if ($ptsY < 0){
                        $ptsY=($highY2SW-$process[1])/$stepY;
                        }
                        $ptsY_Y1=$ptsY-1;
                        $ptsY_Y3=$ptsY+1;
                        printf "%5d %9.3f %9.3f %8.3f %8.3f %+e %s %4.0f %4.0f %4.0f %4.0f\n",$i,$ptsX,$ptsY,$process[2],$process[1],700000,$process[0],$ptsX_X1,$ptsX_X3,$ptsY_Y1,$ptsY_Y3;
                        $i++;
                };
        };
close (IN);

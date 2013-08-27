#! /bin/csh -f

set x = 0

while ( $x <= 35 )
	cd $x.fid
	cp ../fft.com .
	./fft.com
	cd ..
	@ x = $x + 1
end

#!/bin/bash

#FONT=/var/tmp/wc170402/INCOMING/zxspectrum.ch8
FONT=/var/tmp/wc170402/INCOMING/zxspectrum.tap
#FONT=/var/tmp/wc170402/INCOMING/sirclive-8x8-1215.psf.bz2
#FONT=/var/tmp/wc170402/INCOMING/fonts/koi8u_8x8.psfu
#FONT=/usr/share/consolefonts/Lat15-VGA8.psf.gz
H=8

# Font types and headers:
# - no header for 'raw'
# - psf1: 4-byte header (magic 0x36 0x04, w/ mode and 'charsize')
# - psf2: 32-byte header (magic 0x72 0xb5 0x4a 0x86, various sizes)
# ...'sirclive' has no header, whereas koi8u/Lat15-VGA8 is psf1
#O=0
O=4
#O=32

# F(ont data): split data section one byte per line.
# 8x8 fonts with header removed match the 96-character "CH8" data format
# of ZX Spectrum at end of ROM (last 768 bytes), but containing 256
# (or more) glyphs.
# To dump from FBZX, SAVE "FONT.CH8" CODE 15616,768
# NB: in CH8, 0x5E (^) is up-arrow, 0x60 (`) pound sign, 0x7F copyright
case ${FONT} in
*.bz2)
	F=(`bzcat ${FONT} | tail -c +$O | hexdump -v -e'1/1 "%x\n"'`)
;;
*.gz)
F=(`zcat ${FONT} | tail -c +$O | hexdump -v -e'1/1 "%x\n"'`)
;;
*.ch8)	# raw; 96 chars from 32-127 (768 bytes)
	F=(`(dd if=/dev/zero bs=1 count=256 ; cat ${FONT}) | hexdump -v -e'1/1 "%x\n"'`)
;;
*.tap)	# as .ch8 but includes 25-byte header
	F=(`(dd if=/dev/zero bs=1 count=256 ; cat ${FONT}) | tail -c +25 | hexdump -v -e'1/1 "%x\n"'`)
;;
*)
	F=(`cat ${FONT} | tail -c +$O | hexdump -v -e'1/1 "%x\n"'`)
;;
esac

#while true; do
	if [ "$1" ] ; then
		T=${1+"$@"}
	fi
	[ "${T}" ] || T=`date +%H:%M:%S`

# prep: get ASCII values for the text we'll print
	e=echo\ -e
	A=$($e -n "$T" | hexdump -v -e'1/1 "%u\n"')

# print: initial $b value '1<<7' assumes 8-pixel character width
	#$e "\033[2J\033[?25l"
	#$e "\033[0;0H"
	for h in `eval $e {0..$[H - 1]}` ; do
		for a in $A ; do
			f=0x${F[$[a*H+h]]}
			b=$((1 << 7))
			while [ $b -gt 0 ] ; do
				hilo=$[f&b]
				#$e -n $[hilo/b]|sed -e 'y/01/ â/'
				$e -n $[hilo/b]|sed -e 'y/01/.@/'
				: $[b>>=1]
			done
		done
		echo
	done
#done

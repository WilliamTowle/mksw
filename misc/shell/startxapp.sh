#!/bin/sh

[ "${DISPLAY}" ] || DISPLAY=:0.0
BINS=`pwd`/toolchain/usr/bin
LIBS=`pwd`/toolchain/usr/lib
XBINS=`pwd`/toolchain/usr/X11R7/bin

if [ "$1" ] ; then
	DISPLAY=${DISPLAY} PATH=${BINS}:${XBINS}:${PATH} LD_LIBRARY_PATH=${LIBS} ${1+"$@"}
else
	[ ! -d ${BINS} -o ! -d ${XBINS} ] && exit 1
	echo "$0: BINS ${BINS}"
	echo "$0: LIBS ${LIBS}"
	echo "$0: XBINS ${XBINS}"
fi

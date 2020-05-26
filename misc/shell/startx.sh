#!/bin/sh

BINS=`pwd`/toolchain/usr/bin
LIBS=`pwd`/toolchain/usr/lib
XBINS=`pwd`/toolchain/usr/X11R7/bin

if [ "$1" ] ; then
	SERVER=$1
	shift
	ARGS=${1+"$@"}

	case ${SERVER} in
	*/Xorg)	# don't force any arguments
	;;
	*/Xvfb)
		[ "${ARGS}" ] || ARGS=":0 -ac -screen 0 640x480x16"
	;;
	*)
		[ "${ARGS}" ] || ARGS=":0 -ac -screen 640x480x16x70"
	;;
	esac
	echo "$0: Passing ARGS ${ARGS}"
	PATH=${BINS}:${XBINS}:${PATH} LD_LIBRARY_PATH=${LIBS} ${SERVER} ${ARGS} 2>&1 | tee `basename $0`.txt
else
	[ ! -d ${BINS} -o ! -d ${XBINS} ] && exit 1
	echo "$0: BINS ${BINS}"
	echo "$0: LIBS ${LIBS}"
	echo "$0: XBINS ${XBINS}"
fi

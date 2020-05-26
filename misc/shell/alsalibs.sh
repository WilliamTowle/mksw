#!/bin/sh

USRDIR=`pwd`/toolchain/usr
ALSADIR=${USRDIR}/lib/alsa-lib

LDLIBS=${USRDIR}/lib

for LD in \
	${ALSADIR}/smixer	\
	; do
		[ -d ${LD} ] && LDLIBS=${LDLIBS}:$LD
	done

if [ "$1" ] ; then
	LD_LIBRARY_PATH=${LDLIBS} ${1+"$@"} 2>&1 | tee `basename $0`.txt
else
	echo "$0: LDLIBS ${LDLIBS}"
fi

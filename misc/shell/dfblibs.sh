#!/bin/sh

USRDIR=`pwd`/toolchain/usr
LDLIBS=${USRDIR}/lib

DFBDIR=''
for F in 1.3-0 1.6-0 1.7-6 1.7-7 ; do
	TESTDIR=`pwd`/toolchain/usr/lib/directfb-${F}
	[ -d ${TESTDIR} ] && DFBDIR=${TESTDIR}
done

if [ -z "${DFBDIR}" ] ; then
	echo "$0: Cannot determine DFBDIR" 1>&2
	exit 1
fi

##

for LD in \
	${DFBDIR}/systems \
	${DFBDIR}/wm \
	${DFBDIR}/interfaces/IDirectFBFont \
	${DFBDIR}/interfaces/IDirectFBImageProvider \
	${DFBDIR}/interfaces/IDirectFBVideoProvider \
	${DFBDIR}/inputdrivers \
	${DFBDIR}/gfxdrivers \
	; do
		LDLIBS=${LDLIBS}:$LD
	done

if [ "$1" ] ; then
	LD_LIBRARY_PATH=${LDLIBS} ${1+"$@"} 2>&1 | tee `basename $0`.txt
else
	echo "$0: LDLIBS ${LDLIBS}"
fi

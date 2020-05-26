#!/bin/sh

FSIMG=$1
shift

if [ -z "${FSIMG}" ] ; then
	echo "$0: No FSIMG, INSTROOT" 1>&2
	exit 1
fi

INSTROOT=$1
shift

if [ -z "${INSTROOT}" ] ; then
	echo "$0: No INSTROOT" 1>&2
	exit 1
else
	( cd ${INSTROOT} && find . | cpio -o -H newc ) | gzip > ${FSIMG}
fi

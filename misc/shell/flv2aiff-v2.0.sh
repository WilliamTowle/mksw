#!/bin/sh

if [ -z "$1" ] ; then
	echo "$0: Expected ARGs" 1>&2
	exit 1
fi

FFMPEG=`which ffmpeg`
if [ -z "${FFMPEG}" ] ; then
	echo "$0: ffmpeg binary not found" 1>&2
	exit 1
fi

while [ "$1" ] ; do
	INFILE=$1
	shift

	OUTOPTS='-f s16le'
	OUTFILE=`dirname ${INFILE}`/`basename ${INFILE} | sed 's/.flv/.aiff/'`
	${FFMPEG} -i ${INFILE} ${OUTOPTS} ${OUTFILE}
done

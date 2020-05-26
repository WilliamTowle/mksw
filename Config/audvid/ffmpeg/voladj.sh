#!/bin/sh -x

parse_max_vol() {
	grep 'Parsed' \
		| sed -n '/max_volume:/ { s/.*: // ; s/^-// ; s/ //g ; p }'
}

voldetect() {
	FILE=$1
	shift

	ffmpeg -i "${FILE}" -af 'volumedetect' -f null /dev/null 2>&1 | parse_max_vol
}

if [ -z "$1" ] ; then
	echo "$0: Expected INFILE[s]" 1>&2
	exit 1
fi

BINDIR=${PWD}/toolchain/usr/bin
[ -d ${BINDIR} ] && export PATH=${BINDIR}:${PATH}

# '-af volumedetect' can be quite verbose, at 54 lines per input file
# With ffmpeg v2.6.3+, the interesting lines/stanzas contain:
#	- the keyword 'Input', with filename on first line
#	- the keyword 'Parsed_', with the various statistics (eight lines)
while [ "$1" ] ; do
	INFILE=$1
	shift

	INCVOL=` voldetect "${INFILE}" `
	[ "${OUTFMT}" ] || OUTFMT=mp3
	OUTFILE=` basename "${INFILE}" | sed 's/m[p4][4a]/'${OUTFMT}'/' `
	echo "Create OUTFILE ${OUTFILE}, extravol ${INCVOL}"
	ffmpeg -i "${INFILE}" -af "volume=${INCVOL}" "${OUTFILE}"
done

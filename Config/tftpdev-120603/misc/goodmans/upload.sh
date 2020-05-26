#!/bin/sh

if [ -z "$1" ] ; then
	echo "$0: No MNTPT" 1>&2
	exit 1
else
	MNTPT=$1
	shift
fi

while [ "$1" ] ; do
	FILE=$1
	shift

	TARGET="${MNTPT}/${FILE}"
	if [ -r "${TARGET}" ] ; then
		echo "${FILE}: exists"
	else
		echo "${FILE}: copying..."
		mkdir -p "`dirname "${TARGET}"`"
		cp "${FILE}" "${TARGET}"
	fi
done

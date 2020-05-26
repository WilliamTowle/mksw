#!/bin/sh

TMPDIR=/usr/tmp

MONTH=$1
if [ -z "$MONTH" ] ; then
	echo "$0: No MONTH supplied"
	exit 1
else
	shift
fi

COMMAND=$*
if [ -z "$COMMAND" ] ; then
	echo "$0: No COMMAND supplied"
	exit 1
else
	shift
fi

ls -l `find ./ -type f ; find ./ -type l` \
	| grep "$MONTH.*:" \
	| sed 's/ -> .*//' | sed 's/.* //' \
	> $TMPDIR/$$.tmp
$COMMAND `cat $TMPDIR/$$.tmp`
rm $TMPDIR/$$.tmp

echo "$0: OK"

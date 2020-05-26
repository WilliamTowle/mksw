#!/bin/sh

ROOTPATH=$1
if [ -z "$ROOTPATH" ] ; then
	echo "$0: ROOTPATH/TERM/ACTION expected"
	exit 1
else
	shift
fi

TERM=$1
if [ -z "$TERM" ] ; then
	echo "$0: .../TERM/ACTION expected"
	exit 1
else
	shift
fi

ACTION=$*
if [ -z "$ACTION" ] ; then
	echo "$0: ../ACTION expected"
	exit 1
fi

ls -l `find $ROOTPATH -type f ; find $ROOTPATH -type l` \
	| grep "$MONTH.*:" \
	| sed 's/ -> .*//' | sed 's/.* //' \
	> $TMPDIR/$$.tmp
$ACTION `cat $TMPDIR/$$.tmp`
rm $TMPDIR/$$.tmp

echo "$0: OK"

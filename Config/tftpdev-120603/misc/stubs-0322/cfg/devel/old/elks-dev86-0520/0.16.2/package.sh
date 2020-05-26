#!/bin/sh

if [ ! -r current.cfg ] ; then
	echo "Confused -- current.cfg missing"
	exit 1
fi

. ./current.cfg
echo '' > tmp.$$
if [ ! -r $BUILDDIR/tmp.$$ ] ; then
	echo "Confused -- not in original BUILDDIR $BUILDDIR"
	exit 1
fi
rm tmp.$$

( cd $TEMPROOT && (
	tar cf - * | bzip2 -9 > $PACKAGETEMP/$PKGNAME-$PKGVER.tbz
))

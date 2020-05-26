#!/bin/sh

if [ ! -r cfg.current ] ; then
	echo "Confused -- cfg.current missing"
	exit 1
fi

. cfg.current
echo '' > tmp.$$
if [ ! -r $BUILDDIR/tmp.$$ ] ; then
	echo "Confused -- not in original BUILDDIR $BUILDDIR"
	exit 1
fi
rm tmp.$$

( cd $TEMPROOT && (
	tar cf - * | ( cd / && tar xvf - )
))

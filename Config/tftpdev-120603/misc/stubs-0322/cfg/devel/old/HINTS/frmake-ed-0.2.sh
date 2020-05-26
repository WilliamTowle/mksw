#!/bin/sh

if [ ! -r cfg.current ] ; then
	echo "Confused -- cfg.current missing"
	exit 1
fi

. cfg.current
cp /dev/null tmp.$$
if [ ! -r $BUILDDIR/tmp.$$ ] ; then
	echo "Confused -- not in original BUILDDIR $BUILDDIR"
	exit 1
fi
rm tmp.$$

if [ ! -r .patched ] ; then
	../Patch.sh .
	cp /dev/null .patched
fi

TOUCH=`( which touch )2>/dev/null`
if [ "$TOUCH" = '' ] ; then
	echo "No 'touch' executable?"
	exit 1
fi


if [ -d $TEMPROOT ] ; then
	/bin/rm -rf $TEMPROOT/*
elif [ -r $TEMPROOT ] ; then
	echo "Confused -- $TEMPROOT not a directory"
	exit 1
else
	mkdir $TEMPROOT
fi
#( cd $TEMPROOT && (
#	mkdir usr
#))

( cd $SOURCETEMP && (
	# fix a symlink vulnerability...
	if [ ! -r buf.c.bak ] ; then
		cp buf.c buf.c.bak &&
		sed 's/int u/int u, sfd/' buf.c.bak | \
			sed '/.*\*mktemp.*/d' | \
			sed 's/.*if (mktemp.*/  sfd= mkstemp(sfn);\
				if ((sfd == -1) || (sfp= fopen(sfn, "w+")) == NULL)/' > buf.c
	fi &&

	# build it
	./configure --prefix=$TEMPROOT/usr --exec-prefix=$TEMPROOT/ &&
	make &&
	make install
))

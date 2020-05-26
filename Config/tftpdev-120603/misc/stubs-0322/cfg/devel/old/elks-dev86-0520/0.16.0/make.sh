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
TEST=`( which test )2>tmp.$$` || {
	echo "No 'test' executable?"
	rm tmp.$$
	exit 1
}
rm tmp.$$


if [ ! -r .patched ] ; then
	( cd $SOURCETEMP && (
		cp Makefile Makefile.backup &&
		sed "s%^PREFIX=.*%PREFIX=$TEMPROOT/usr%" Makefile.backup > Makefile
	))
	../Patch.sh .
	echo '' > .patched
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
	make
	make install BINDIR=$TEMPROOT/usr/bin LIBDIR=$TEMPROOT/lib
))
( cd $TEMPROOT && (
	( cd usr/lib && mv ../../lib/bcc-cc1 ./ )
	( cd usr/lib && mv ../../lib/ccopt ./ )
	( cd usr/lib && mv ../../lib/unproto ./ )

	( cd usr/bin && ln -s ../lib/bcc-cc1 ./ )
	( cd usr/bin && ln -s ../lib/ccopt ./ )
	( cd usr/bin && ln -s ../lib/unproto ./ )
))

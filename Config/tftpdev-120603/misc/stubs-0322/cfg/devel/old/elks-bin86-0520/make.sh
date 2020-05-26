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
UNAME=`( which uname )2>tmp.$$` || {
	echo "No 'uname' executable?"
	rm tmp.$$
	exit 1
}
GCC=`( which gcc )2>tmp.$$` || {
	echo "No 'gcc' executable?"
	rm tmp.$$
	exit 1
}
EXPR=`( which expr )2>tmp.$$` || {
	echo "No 'expr' executable?"
	rm tmp.$$
	exit 1
}
rm tmp.$$

if [ ! -r .patched ] ; then
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

( cd $TEMPROOT && (
	mkdir usr usr/bin usr/man
))
( cd $SOURCETEMP && (
	make
	make install BINDIR=$TEMPROOT/usr/bin MANDIR=$TEMPROOT/usr/man
			## LIBDIR=$TEMPROOT/lib
))
#( cd $TEMPROOT && (
#))

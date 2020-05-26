#!/bin/make
## based on LFS v3.2
include ${BUILDDIR}/current.cfg

.PHONY: build build-static check-be prelim

default: build

#
#
#

check-be:
	if [ ! -r /dev/null ] ; then \
		mknod /dev/null c 1 3 ;\
	fi
	which sed

##prelim: extras.tgz
#prelim:
#	( cd ${TEMPROOT} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

build: check-be
	CC=gcc ./configure --prefix=${TEMPROOT}/usr --bindir=${TEMPROOT}/bin
	make
	make install
	cd ${TEMPROOT}/bin
	ln -sf bash sh

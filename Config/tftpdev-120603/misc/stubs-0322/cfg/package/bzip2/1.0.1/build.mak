#!/bin/make
## based on LFS v3.2
include ${BUILDDIR}/current.cfg

.PHONY: build build-static check-be prelim

default: build

#
#
#

#check-be:
#	which patch

#prelim: extras.tgz
prelim:
	( cd ${TEMPROOT} && ( \
		mkdir bin lib usr	;\
		mkdir usr/include usr/lib ;\
		mkdir usr/share usr/share/man usr/share/man/man1 \
	) || exit 1 )

build: prelim
	make -f Makefile-libbz2_so
	make bzip2recover libbz2.a
	if [ ! -r libbz.so ] ; then \
		ln -s libbz2.so.1.0.1 libbz.so ;\
	fi
	cp bzip2-shared ${TEMPROOT}/bin/bzip2
	cp bzip2recover ${TEMPROOT}/bin/
	cp bzip2.1 ${TEMPROOT}/usr/share/man/man1/
	cp bzlib.h ${TEMPROOT}/usr/include/
	cp -a libbz2.so* ${TEMPROOT}/lib/
	cp libbz2.a ${TEMPROOT}/usr/lib/
	cd ${TEMPROOT}/usr/lib
	ln -sf ../../lib/libbz2.so
	cd ${TEMPROOT}/bin
	ln -sf bzip2 bunzip2
	ln -sf bzip2 bzcat
	cd ${TEMPROOT}/usr/share/man/man1
	ln -sf bzip2.1 bunzip2.1
	ln -sf bzip2.1 bzcat.1
	ln -sf bzip2.1 bzip2recover.1

build-static: prelim
	make CC="gcc -static"
	make PREFIX=${TEMPROOT}/usr install
	( cd ${TEMPROOT}/usr/bin && mv bunzip2 bzip2 bzcat ${TEMPROOT}/bin )

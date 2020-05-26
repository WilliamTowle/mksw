#!/bin/make
## based on LFS v3.2
include ${BUILDDIR}/current.cfg

.PHONY: build build-static check-be prelim

default: build

#
#
#

#check-be:
#	which pwd
#	which tail
#	which test

#prelim: extras.tgz
#prelim:
#	( cd ${TEMPROOT} &&\
#		mkdir usr usr/lib &&\
#		mkdir usr/local usr/local/bin &&\
#		mkdir usr/local/man usr/local/man/man1 \
#	)

#build: check-be prelim
build \
build-static:
	make prefix=/usr
	make prefix=/usr DESTDIR=${TEMPROOT} install
#	cp bin-i386/diet ${TEMPROOT}/usr/local/bin/
#	cp bin-i386/start.o ${TEMPROOT}/usr/lib/
#	cp bin-i386/dietlibc.a ${TEMPROOT}/usr/lib/
## diet-i dietlibc.a
#	cp diet.1 ${TEMPROOT}/usr/local/man/man1/

##build-static: check-be prelim
#build-static: prelim

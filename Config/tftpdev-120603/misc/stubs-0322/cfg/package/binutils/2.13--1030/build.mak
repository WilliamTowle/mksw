#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

#
#
#

check-be:
	which pwd
	which tail
	which test

prelim:
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

build: check-be prelim
#	./configure --prefix=/usr --disable-nls
	./configure --prefix=/usr --target=${TARGET_ARCH} --disable-nls
	make tooldir=/usr
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr tooldir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

build-static: check-be prelim
	./configure --host=`uname -m`-`uname -s | tr A-Z a-z` \
		--target=${TARGET_ARCH}-linux \
		--prefix=/usr --disable-nls
	make LDFLAGS=-all-static
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

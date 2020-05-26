#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-cross build-static check-be prelim

default: build

#
#
#

check-be:
	which gcc
	which make
	which sed

prelim:
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

build: check-be prelim
	CPPFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
	make
	make install

build-cross: check-be prelim
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} CC=${CROSS_PREFIX}-gcc CPPFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
	make install

build-static: check-be prelim
	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
	make LDFLAGS=-static
	make install

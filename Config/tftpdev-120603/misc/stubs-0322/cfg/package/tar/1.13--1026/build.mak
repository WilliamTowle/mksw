#!/bin/gmake
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: build build-cross build-static check-be prelim

default: build

check-be:
	if [ ! -r /dev/null ] ; then \
		mknod /dev/null c 1 3 ;\
	fi

prelim:
	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && \
		mkdir bin usr && \
		mkdir usr/info \
	)

build: check-be prelim
	CC=`which gcc` ./configure --prefix=/usr \
		--host=`uname -m` \
		--target=${TARGET_ARCH} \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-largefile --disable-nls
	make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

build-cross: check-be prelim
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} CC=${CROSS_PREFIX}-gcc ./configure --prefix=/usr \
		--host=`uname -m` \
		--target=${TARGET_ARCH} \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-largefile --disable-nls
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

build-static: check-be prelim
	CC=gcc ./configure --prefix=/usr \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-nls
	make LDFLAGS=-static
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#
#
#

.PHONY: build-cross build-native

build-cross:
	CC=${CROSS_PREFIX}-gcc CPPFLAGS=-Dre_max_failures=re_max_failures2 \
		./configure
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER} install

#build-lfs-4.0:
#	patch -Np1 -i ../findutils-4.1.patch &&
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 \
#	./configure --prefix=$LFS/static &&
#	make LDFLAGS=-static &&
#	make install

#build-native:
##build: prelim
#	./configure --prefix=/usr
#	make localstatedir=/var/lib/misc
#	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr localstatedir=${INSTTMP}/${PKGNAME}-${PKGVER}/var/lib/misc libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

#build-static: prelim
#	./configure --prefix=/usr
#	make LDFLAGS=-static localstatedir=/var/lib/misc
#	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr localstatedir=/var/lib/misc libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

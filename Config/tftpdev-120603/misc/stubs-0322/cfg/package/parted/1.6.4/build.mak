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
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		CC=${CROSS_PREFIX}-gcc ./configure --prefix=/usr
	make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install
#
#	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
#		make CC=${CROSS_PREFIX}-gcc
#	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

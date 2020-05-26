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
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/sbin
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make CC=${CROSS_PREFIX}-gcc
	make DESTDIR=${INSTTMP}/${PKGNAME}-${PKGVER} install

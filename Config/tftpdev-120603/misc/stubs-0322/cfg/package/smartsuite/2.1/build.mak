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
		make CC=${CROSS_PREFIX}-gcc
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin
	cp smartctl ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin/smartctl
	cp smartd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/sbin/smartd
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man8
	cp smart*.8 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man8/

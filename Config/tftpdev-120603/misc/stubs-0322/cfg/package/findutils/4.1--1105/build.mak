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

#include ${CONF}
#include ${UNIT}
#
#.PHONY: build build-cross build-static check-be prelim
#
#default: build
#
##
##
##
#
##check-be:
##	which patch
#
#prelim:
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
##	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

#
#
#

.PHONY: build-cross build-native

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		./configure CC=${CROSS_PREFIX}-gcc --prefix=/usr
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make localstatedir=/var/lib/misc
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr localstatedir=${INSTTMP}/${PKGNAME}-${PKGVER}/var/lib/misc libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

build-native:
#build: prelim
	./configure --prefix=/usr
	make localstatedir=/var/lib/misc
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr localstatedir=${INSTTMP}/${PKGNAME}-${PKGVER}/var/lib/misc libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

#build-static: prelim
#	./configure --prefix=/usr
#	make LDFLAGS=-static localstatedir=/var/lib/misc
#	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr localstatedir=/var/lib/misc libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

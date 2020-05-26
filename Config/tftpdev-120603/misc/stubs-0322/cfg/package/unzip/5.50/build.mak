#!/bin/make
# WmT, Thu Jan  9 21:58:10 GMT 2003

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
#	make -f unix/Makefile list
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make -f unix/Makefile CC=${CROSS_PREFIX}-gcc generic
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin
	for FILE in unzip funzip unzipsfx ; do \
		cp $$FILE ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/ ;\
	done
	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1
	cp man/*.1 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1/

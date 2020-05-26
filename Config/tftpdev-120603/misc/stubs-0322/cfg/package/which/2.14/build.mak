#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: check-be default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

check-be:
	which gcc
	which make
	which sed

#prelim:
#	[ "${INSTTMP}" ] || ( echo "INSTTMP not set" ; false )
#	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

.PHONY: build-cross build-toolroot

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} CC=${CROSS_PREFIX}-gcc CPPFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
	make install

build-toolroot: check-be
	./configure --prefix=${TOOLROOT}/usr --bindir=${TOOLROOT}/bin
	make
	make install

#build-static: check-be prelim
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
#	make LDFLAGS=-static
#	make install

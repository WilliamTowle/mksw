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

#check-be:
#	which gcc
#	which make
#	which sed

.PHONY: build-cross build-native

build-cross:
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} \
		make CC=${CROSS_PREFIX}-gcc
	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER} install

#build-native: check-be
#	./configure --prefix=${TOOLROOT}/usr --bindir=${TOOLROOT}/bin
#	make
#	make install

#build-static: check-be prelim
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
#	make LDFLAGS=-static
#	make install

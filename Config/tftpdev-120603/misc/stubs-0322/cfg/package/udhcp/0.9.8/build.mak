#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
##
#	which cmp
#
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross build-native

#prelim:
#	( cd ${TOOLROOT} && ( \
#		[ -d usr/bin ] || mkdir -p usr/bin ;\
#		[ -d usr/man/man1 ] || mkdir -p usr/man/man1 \
#	) || exit 1 ) || exit 1

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
	 CC=${CROSS_PREFIX}-gcc \
		make CFLAGS="-nostdinc -I${TOOLROOT}/usr/src/linux/include/ -I${TOOLROOT}/usr/${CROSS_PREFIX}/include -I${TOOLROOT}/usr/${CROSS_PREFIX}/include/linux"
	make DESTDIR=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

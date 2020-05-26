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

.PHONY: build-toolroot

#prelim:
#	( cd ${TOOLROOT} && ( \
#		[ -d usr/bin ] || mkdir -p usr/bin ;\
#		[ -d usr/man/man1 ] || mkdir -p usr/man/man1 \
#	) || exit 1 ) || exit 1

build-toolroot:
	mkdir -p ${SRCTMP}/gcc-build
	( cd ${SRCTMP}/gcc-build && \
		${SRCTMP}/${SRCXPATH}/configure \
		 --prefix=${TOOLROOT}/usr \
		 --enable-languages=c,c++ \
		 --disable-nls --disable-largefile \
			|| exit 1 ;\
		make bootstrap || exit 1 ;\
		make || exit 1 ;\
		make install || exit 1 \
	) || exit 1

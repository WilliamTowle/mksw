#!/bin/make

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#.PHONY: build build-static check-be prelim
#
#default: build
#
##
##
##
#
#check-be:
#	which pwd
#	which tail
#	which test
#
#prelim:
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
##	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

.PHONY: build-toolroot

build-toolroot:
	mkdir -p ${SRCTMP}/binutils-build
#	( cd ${SRCTMP}/binutils-build && \
#		${SRCTMP}/${SRCXPATH}/configure \
#		 --prefix=${TOOLROOT}/usr \
#		 --disable-nls --disable-largefile \
#		 --target=${TARGET_MACH}-linux \
#			|| exit 1 ;\
#		make || exit 1 ;\
#		make install || exit 1 \
#	) || exit 1
	( cd ${SRCTMP}/binutils-build && \
		${SRCTMP}/${SRCXPATH}/configure \
		 --prefix=${TOOLROOT}/usr \
		 --disable-nls --disable-largefile \
			|| exit 1 ;\
		make || exit 1 ;\
		make install || exit 1 \
	) || exit 1

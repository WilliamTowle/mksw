#!/bin/gmake
# syslinux (1.76, 21/10/2002)

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
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-uclibc/bin:${PATH} \
		./configure CC=${TARGET_PREFIX}-gcc
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-uclibc/bin:${PATH} \
		make
	make install

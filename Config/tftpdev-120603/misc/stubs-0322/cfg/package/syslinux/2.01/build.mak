#!/bin/gmake
# syslinux (1.76, 21/10/2002)

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross build-native

build-cross \
build-native:
	make
	make INSTALLROOT=${TOOLROOT} install

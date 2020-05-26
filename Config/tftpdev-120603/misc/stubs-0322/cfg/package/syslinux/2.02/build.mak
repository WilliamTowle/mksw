#!/bin/gmake
# syslinux (1.76, 21/10/2002)
# syslinux (2.02, 13/02/2003 makefile 15/03/2003)

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross build-toolroot

build-cross: build-toolroot

build-toolroot:
	make
	make INSTALLROOT=${TOOLROOT} install

#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-toolroot

build-toolroot:
	./configure --prefix=${TOOLROOT}/usr
	make
	make runtests
	make install
	make clean

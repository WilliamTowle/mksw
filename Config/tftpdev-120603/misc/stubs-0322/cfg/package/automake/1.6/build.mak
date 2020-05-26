#!/bin/gmake
# 'indy' rpm compile, 18/10/2002

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-native

build-native:
	./configure --prefix=${TOOLROOT}/usr \
	make
	make install

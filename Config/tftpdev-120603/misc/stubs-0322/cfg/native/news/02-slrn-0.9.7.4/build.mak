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
#	# --with-slang-library=DIR
#	# --with-slang-includes=DIR
#	# --with-slrnpull
#	# --enable-inews | --enable-force-inews
	make
#	strip src/slrn src/slrnpull
	make install
#	make install-contrib

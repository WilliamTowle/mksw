#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
#
	which cmp
#
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross build-toolroot prelim

prelim:
	( cd ${TOOLROOT} && ( \
		[ -d usr/bin ] || mkdir -p usr/bin ;\
		[ -d usr/man/man1 ] || mkdir -p usr/man/man1 \
	) || exit 1 ) || exit 1

build-cross: build-toolroot

build-toolroot: prelim
## 'autoconf' causes 'configure' rebuild (recommended for CVS sources)
#	autoconf
	./configure --prefix=${TOOLROOT}/usr
	make
	make install

#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	which nasm
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-cross

build-cross:
# compression breaks due to busybox 'tail' :(
	make COMPRESS=''
	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install
# ...and symlinks don't work:
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin && ( \
		for LINK in `ls e3??` ; do \
			ln -sf e3 $$LINK ;\
		done \
	))

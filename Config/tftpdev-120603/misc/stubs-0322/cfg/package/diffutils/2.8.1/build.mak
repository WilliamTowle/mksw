#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#check-be:
#	which patch

#prelim:
#	( cd ${INSTTMP} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

.PHONY: build-cross build-toolroot

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		./configure CC=${CROSS_PREFIX}-gcc \
			--prefix=/usr \
			--disable-nls
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

build-toolroot:
	./configure --prefix=/usr
	make
	make prefix=${TOOLROOT}/usr install

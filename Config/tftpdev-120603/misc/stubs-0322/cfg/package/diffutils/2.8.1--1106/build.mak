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

.PHONY: build-cross build-native

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		./configure --prefix=/usr \
			--host=`uname -m` \
			--target=${TARGET_ARCH}
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

build-native:
	./configure --prefix=/usr
	make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

## don't influence CPPFLAGS for glibc 2.2.x
#build-static:
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 \
#		./configure --prefix=/usr --disable-nls
#	make LDFLAGS=-static
#	make prefix=${INSTTMP}/usr install

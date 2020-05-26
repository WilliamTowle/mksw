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

#.PHONY: build build-static check-be prelim
#
#default: build
#
##
##
##
#
#check-be:
#	which pwd
#	which tail
#	which test
#
#prelim:
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
##	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

.PHONY: build-native

build-native:
#	./configure --prefix=${TOOLROOT}/usr \
#		--host=`uname -m`-`uname -s | tr A-Z a-z` \
#		--target=${TARGET_ARCH} \
#		--disable-nls
	./configure --prefix=${TOOLROOT}/usr \
		--disable-nls
	make LDFLAGS=-all-static
	make prefix=${TOOLROOT}/usr install

#build-static: check-be prelim
#	./configure --host=`uname -m`-`uname -s | tr A-Z a-z` \
#		--target=${TARGET_ARCH}-linux \
#		--prefix=/usr --disable-nls
#	make LDFLAGS=-all-static
#	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install

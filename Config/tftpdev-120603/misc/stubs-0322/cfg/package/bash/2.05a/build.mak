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


#include ${BUILDDIR}/current.cfg
#
#.PHONY: build build-static check-be prelim
#
#default: build
#
##
##
##
#
#check-be:
#	if [ ! -r /dev/null ] ; then \
#		mknod /dev/null c 1 3 ;\
#	fi
#	which sed
#
###prelim: extras.tgz
##prelim:
##	( cd ${TEMPROOT} && ( \
##		mkdir bin usr ;\
##		mkdir usr/info \
##	) || exit 1 )

.PHONY: build-cross

#build: check-be
build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
	CC=${CROSS_PREFIX}-gcc \
		./configure \
			--host=`uname -m`-`uname -s | tr A-Z a-z` \
			--build=`uname -m`-`uname -s | tr A-Z a-z` \
			--target=${TARGET_ARCH} \
			--prefix=/usr --bindir=/bin
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make
	make install
	( cd ${TEMPROOT}/bin && ln -sf bash sh )

build-static:
	./configure --enable-static-link \
		--prefix=/usr --bindir=/bin
	make
	make	prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr \
		bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin install
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/bin && ln -sf bash sh )

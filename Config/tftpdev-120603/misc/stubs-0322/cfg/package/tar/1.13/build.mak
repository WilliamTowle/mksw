#!/bin/gmake
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	which ar
	which cmp
	which grep
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#.PHONY: build build-cross build-static check-be prelim
#
#default: build
#
#check-be:
#	if [ ! -r /dev/null ] ; then \
#		mknod /dev/null c 1 3 ;\
#	fi
#
#prelim:
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && \
#		mkdir bin usr && \
#		mkdir usr/info \
#	)

.PHONY: build-cross build-toolroot

build-cross:
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} CC=${CROSS_PREFIX}-gcc ./configure --prefix=/usr \
		--host=`uname -m` \
		--target=${TARGET_ARCH} \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-largefile --disable-nls
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make
	make prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin libexecdir=${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin install

build-toolroot:
	CC=`which gcc` ./configure --prefix=${TOOLROOT}/usr \
		--host=`uname -m` \
		--target=${TARGET_ARCH} \
		--bindir=/bin \
		--libexecdir=/usr/bin \
		--disable-largefile --disable-nls
	make
	make prefix=${TOOLROOT}/usr bindir=${TOOLROOT}/bin libexecdir=${TOOLROOT}/usr/bin install

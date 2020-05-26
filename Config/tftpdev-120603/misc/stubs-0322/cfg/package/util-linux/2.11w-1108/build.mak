#!/bin/make
## based on LFS v3.2

include ${CONF}
include ${UNIT}

.PHONY: check-be default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

check-be:
	which gcc
	which make
	which sed

#prelim:
#	[ "${INSTTMP}" ] || ( echo "INSTTMP not set" ; false )
#	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
#	[ -d ${INSTTMP}/${PKGNAME}-${PKGVER} ] || mkdir ${INSTTMP}/${PKGNAME}-${PKGVER}
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin usr ;\
#		mkdir usr/info \
#	) || exit 1 )

.PHONY: build-cross build-native

build-cross:
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} CC=${CROSS_PREFIX}-gcc CFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}
#
#	# full `make` fails -- on "mount" (which busybox provides)
#	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make
#	# disk-utils gives us fdformat/fdformat.8
	( cd disk-utils && PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make )
#	# fdisk and sfdisk:
	( cd fdisk && PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make )
##	# login-utils gives us passwd/passwd.1
#	( cd login-utils && PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make )
##	# sys-utils gives us rdev: (but doesn't work)
#	( cd sys-utils && PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make )
#
#	# since we omit a full `make`, don't full `install`?
#	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER} install
	( cd ${INSTTMP} && mkdir -p fdformat-${PKGVER}/usr/bin fdformat-${PKGVER}/usr/man/man8 )
	( cd disk-utils && cp fdformat ${INSTTMP}/fdformat-${PKGVER}/usr/bin/ && cp fdformat.8 ${INSTTMP}/fdformat-${PKGVER}/usr/man/man8/ )
	( cd fdisk && make SBINDIR=${INSTTMP}/fdisk-${PKGVER}/sbin MAN8DIR=${INSTTMP}/fdisk-${PKGVER}/usr/man/man8 install )

#build-native: check-be
#	./configure --prefix=${TOOLROOT}/usr --bindir=${TOOLROOT}/bin
#	make
#	make install

#build-static: check-be prelim
#	CPPFLAGS=-Dre_max_failures=re_max_failures2 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}/usr --bindir=${INSTTMP}/${PKGNAME}-${PKGVER}/bin
#	make LDFLAGS=-static
#	make install

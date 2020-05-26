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

.PHONY: build-cross build-native

prelim:
	[ -r MCONFIG.old ] || cp MCONFIG MCONFIG.old

build-cross: prelim
#	strip out the _FILE_OFFSET_BITS=64 assumption (since we
#	use 32 ...and the compiler might complain otherwise)
	grep -v _FILE_OFFSET_BITS MCONFIG.old > MCONFIG
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} CC=${CROSS_PREFIX}-gcc CFLAGS=-D_FILE_OFFSET_BITS=32 ./configure --prefix=${INSTTMP}/${PKGNAME}-${PKGVER}
#
#	# full `make` fails -- on "mount" (which busybox provides)
#	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make
#	# disk-utils gives us fdformat/fdformat.8
	( cd disk-utils && PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make )
#	# fdisk and sfdisk:
	( cd fdisk && PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make )
##	# login-utils gives us agetty/passwd/passwd.1
#	( cd login-utils && PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make )
##	# sys-utils gives us rdev: (but doesn't work)
#	( cd sys-utils && PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} make )
#
#	# since we omit a full `make`, don't full `install`?
#	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER} install
	( cd ${INSTTMP} && mkdir -p fdformat-${PKGVER}/usr/bin fdformat-${PKGVER}/usr/man/man8 )
	( cd disk-utils && cp fdformat ${INSTTMP}/fdformat-${PKGVER}/usr/bin/ && cp fdformat.8 ${INSTTMP}/fdformat-${PKGVER}/usr/man/man8/ )
	( cd fdisk && make SBINDIR=${INSTTMP}/fdisk-${PKGVER}/sbin MAN8DIR=${INSTTMP}/fdisk-${PKGVER}/usr/man/man8 install )

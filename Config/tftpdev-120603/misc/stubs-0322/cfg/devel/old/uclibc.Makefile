#!/usr/bin/gmake

default: uclibc-pkg

HERE=$(shell pwd)

SRCTMP=${HERE}
TEMP=$(shell dirname ${HERE})
TOOLROOT=$(shell basename ${TEMP})
TOPLEV=$(shell dirname ${TEMP})

TARGET_MACH=i386

UCLIBCSRC=u/uClibc-0.9.15.tar.bz2
UCLIBCPATCH=
UCLIBCPATH=uClibc-0.9.15

PKGTEMP=pkgtemp

.PHONY: uclibc-prelim

uclibc-prelim:
#	[ ! -d ${TOOLROOT}/usr/i386-uclibc ] || rm -rf ${TOOLROOT}/usr/i386-uclibc
	if [ -L Config ] ; then rm ./Config ; else true ; fi
	cat ./extra/Configs/Config.${TARGET_MACH} \
		| sed "s%^DEVEL_PREFIX *=.*%%" \
		| sed "s%^SYSTEM_DEVEL_PREFIX *=.*%%" \
		| sed "s%^KERNEL_SOURCE *=.*%KERNEL_SOURCE=${TOPLEV}/${TOOLROOT}/usr/src/linux%" \
		| sed "s%^SHARED_LIB_LOADER_PATH *=.*%SHARED_LIB_LOADER_PATH=/lib%" \
		| sed "s%^UNIX98PTY_ONLY *=.*%UNIX98PTY_ONLY=false%" \
		> ./Config
	( cd extra/gcc-uClibc && ( \
		cp Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed 's/	gcc /	$${XPREFIX}gcc /' \
			> Makefile ;\
	) || exit 1 ) || exit 1

.PHONY: uclibc-pkg uclibc-pkg-sub

uclibc-pkg: ${SRCTMP}/${UCLIBCPATH}
	( cd ${SRCTMP}/${UCLIBCPATH} && ${MAKE} TOPLEV=${TOPLEV} -f ${SRCTMP}/uclibc.Makefile uclibc-pkg-sub )

uclibc-pkg-sub:
#	make \
#		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc
#	make \
#		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
#		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
#		install
#	-make \
#		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
#		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
#		PREFIX=${TOPLEV}/${TOOLROOT} install_target
	make \
		CC=i386-uclibc-gcc \
		DEVEL_PREFIX=${TOPLEV}/${PKGTEMP}/usr/i386-uclibc
	make \
		CC=i386-uclibc-gcc \
		DEVEL_PREFIX=${TOPLEV}/${PKGTEMP}/usr/i386-uclibc \
		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${PKGTEMP}/usr/i386-uclibc \
		install
	-make \
		CC=i386-uclibc-gcc \
		DEVEL_PREFIX=${TOPLEV}/${PKGTEMP}/usr/i386-uclibc \
		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${PKGTEMP}/usr/i386-uclibc \
		PREFIX=${TOPLEV}/${PKGTEMP} install_target

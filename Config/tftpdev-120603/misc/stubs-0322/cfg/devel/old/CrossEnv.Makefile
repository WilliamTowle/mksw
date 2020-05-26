#!/usr/bin/gmake
PREFIXES="BU GCC"
# package source details -- PKGNAME, PKGVER, PKGURLS, SRCPATH
BU_PKGNAME=binutils
BU_PKGVER=2.13
BU_PKGURLS=
BU_SRCPATH=${SRCDIR}/b
BU_PATCHES=
#
GCC2723VER=2.7.2.3
GCC2723PATCHES=
#
GCC29532VER=2.95.3
GCC29532PATCHES=gcc-2.95.3-2.patch
#
GCC32SRC=g/gcc-3.2.tar.bz2
#GCC32PATCHES=gcc-3.2.patch *** there's a second!!! ***
GCC32PATCHES=gcc-3.2.patch
#
GCC_PKGNAME=gcc
GCC_PKGVER=${GCC32VER}
GCC_PKGURLS=
GCC_SRCPATH=${SRCDIR}/g
GCC_PATCHES=${GCC32PATCHES}
# package extract details -- PKGFILE
BU_PKGFILE=${BU_PKGNAME}-${BU_PKGVER}
BU_SRCXPATH=${BU_PKGNAME}-${BU_PKGVER}
#
GCC_PKGFILE=${GCC_PKGNAME}-${GCC_PKGVER}
GCC_SRCXPATH=${GCC_PKGNAME}-${GCC_PKGVER}
#
PACKAGES="${BU_PKGNAME}-${BU_PKGVER} ${GCC_PKGNAME}-${GCC_PKGVER}"

#GCC32PATH=gcc-3.2
#GCCSRC=${GCC2953SRC}
#GCCPATCH=${GCC2953PATCH}
#GCCPATH=${GCC2953PATH}
#
#LINUXVER=2.0.39
#LINUXSRC=l/linux-${LINUXVER}.tar.bz2
#LINUXPATCH=
#LINUXPATH=linux
#
#UCLIBCSRC=u/uClibc-0.9.15.tar.bz2
#UCLIBCPATCH=
#UCLIBCPATH=uClibc-0.9.15

SOURCE=sources
TARGET_MACH=i386
TARGET_ARCH=${TARGET_MACH}-linux
#
TOPLEV=${shell pwd}
TOOLROOT=mklx-${TARGET_MACH}
SRCTMP=mklx-${TARGET_MACH}/srctmp

BINUSRC=b/binutils-2.13.tar.bz2
BINUPATH=binutils-2.13

GCC2723SRC=g/gcc-2.7.2.3.tar.bz2
GCC2723PATCH=
GCC2723PATH=gcc-2.7.2.3
GCC2953SRC=g/gcc-2.95.3.tar.bz2
GCC2953PATCH=g/gcc-2.95.3-2.patch.bz2
GCC2953PATH=gcc-2.95.3
GCC32SRC=g/gcc-3.2.tar.bz2
# actually two patches
GCC32PATCH=g/gcc-3.2.patch.bz2
GCC32PATH=gcc-3.2
GCCSRC=${GCC2953SRC}
GCCPATCH=${GCC2953PATCH}
GCCPATH=${GCC2953PATH}

LINUXVER=2.0.39
LINUXSRC=l/linux-${LINUXVER}.tar.bz2
LINUXPATCH=
LINUXPATH=linux

UCLIBCSRC=u/uClibc-0.9.15.tar.bz2
UCLIBCPATCH=
UCLIBCPATH=uClibc-0.9.15

HMACH=`uname -m | sed 's/[456]86/386/'`-`uname -s | tr A-Z a-z`
TMACH=i386-linux

##
##	extract stuff
##

.phony: srctmp

srctmp:
	[ -d ${SRCTMP} ] || mkdir -p ${SRCTMP}

.phony: extract extract-binutils extract-gcc extract-uclibc

extract: extract-binutils extract-gcc extract-linux extract-uclibc

extract-binutils: srctmp ${SOURCE}/${BINUSRC}
	bzcat ${SOURCE}/${BINUSRC} | ( cd ${SRCTMP} && tar xvf - )

extract-gcc: srctmp ${SOURCE}/${GCCSRC}
	bzcat ${SOURCE}/${GCCSRC} | ( cd ${SRCTMP} && tar xvf - )
	[ -n "${GCCPATCH}" ] && bzcat ${SOURCE}/${GCCPATCH} | ( cd ${SRCTMP}/${GCCPATH} && patch -p1 -i - )

extract-linux: srctmp ${SOURCE}/${LINUXSRC}
	bzcat ${SOURCE}/${LINUXSRC} | ( cd ${SRCTMP} && tar xvf - )

extract-uclibc: srctmp ${SOURCE}/${UCLIBCSRC}
	bzcat ${SOURCE}/${UCLIBCSRC} | (cd ${SRCTMP} && tar xvf - )

##
## build stuff
##

.phony: toolroot

toolroot:
	[ -d ${TOOLROOT} ] || mkdir ${TOOLROOT}

.phony: build build-binutils build-binutils-sub

build: build-binutils build-gcc-pass1 build-linux build-uclibc

build-binutils: toolroot ${SRCTMP}/${BINUPATH}
	[ -d ${TOOLROOT}/usr ] || mkdir ${TOOLROOT}/usr
	[ -d ${SRCTMP}/binutils ] || mkdir ${SRCTMP}/binutils
	( cd ${SRCTMP}/binutils && ${MAKE} TOPLEV=${TOPLEV} -f ${TOPLEV}/Makefile build-binutils-sub )

build-binutils-sub:
	../${BINUPATH}/configure --prefix=${TOPLEV}/${TOOLROOT}/usr \
		--host=${HMACH} \
		--target=${TARGET_ARCH} \
		--disable-nls
	make LDFLAGS=-all-static
	make prefix=${TOPLEV}/${TOOLROOT}/usr install

build-gcc-pass1: toolroot ${SRCTMP}/${GCCPATH}
	[ ! -r ${SRCTMP}/${GCCPATH}/contrib/egcs_update ] || ( cd ${SRCTMP}/${GCCPATH} && ./contrib/egcs_update --touch )
	[ -d ${SRCTMP}/gcc ] || mkdir ${SRCTMP}/gcc
	( cd ${SRCTMP}/gcc && ${MAKE} TOPLEV=${TOPLEV} -f ${TOPLEV}/Makefile build-gcc-pass1-sub )
	( cd ${TOPLEV}/${TOOLROOT}/usr/bin && ln -sf gcc cc )

build-gcc-pass1-sub:
	../${GCCPATH}/configure --prefix=${TOPLEV}/${TOOLROOT}/usr \
		--host=${HMACH} --target=${TARGET_ARCH} \
		--enable-languages=c --enable-threads=posix \
		--disable-nls
	make BOOT_LDFLAGS=-static bootstrap
	make prefix=${TOPLEV}/${TOOLROOT}/usr install

.phone: build-linux build-linux-sub

build-linux:
#	[ -n "${PKGNAME}" ] && [ -n "${LINUXVER}" ]
#	[ -d "${SRCXPATH}" ]
	[ -d ${TOOLROOT} ] || mkdir ${TOOLROOT}
	( cd ${TOOLROOT} && ( \
		[ -d usr ] || mkdir usr ;\
		[ -d usr/src ] || mkdir usr/src ;\
		[ -d usr/src/linux-${LINUXVER} ] || mkdir usr/src/linux-${LINUXVER} ;\
		( cd usr/src && ln -sf linux-${LINUXVER} ./linux ) \
	) || exit 1 )
#	mkdir -p ${INSTTMP}/linux${LINUXVER}-headers
	cat etc/mkd-dist/fr/XX01-linux-2.0.39/srcdelta.tgz | gzip -d | ( cd ${SRCTMP}/${LINUXPATH} && tar xvf - )
	( cd ${SRCTMP}/${LINUXPATH} && ${MAKE} TOPLEV=${TOPLEV} -f ${TOPLEV}/Makefile build-linux-sub )

build-linux-sub:
# [lfs] make mrproper
# [lfs; "configure needs bash"] yes "" | make config
#	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD
## Rewrite makefile so as not to use uClibc compiler wrapper by mistake
#	cat Makefile.OLD \
#		| sed 's%^HOSTCC.*=.*gcc%HOSTCC=/usr/bin/gcc%' \
#		> Makefile
	#make clean dep modules bzImage
	make clean
	make dep
	( tar cf - .config * ) | ( cd ${TOPLEV}/${TOOLROOT}/usr/src/linux-${LINUXVER} && tar xvf - )
##	( cd ${TOOLROOT} && tar cf - usr/src/linux usr/src/linux-${LINUXVER} ) | ( cd ${INSTTMP}/linux${LINUXVER}-headers && tar xvf - )

.phony: build-uclibc build-uclibc-sub

build-uclibc: toolroot ${SRCTMP}/${UCLIBCPATH}
	( cd ${SRCTMP}/${UCLIBCPATH} && ${MAKE} TOPLEV=${TOPLEV} -f ${TOPLEV}/Makefile build-uclibc-sub )

build-uclibc-prelim:
	[ ! -d ${TOOLROOT}/usr/i386-uclibc ] || rm -rf ${TOOLROOT}/usr/i386-uclibc
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

build-uclibc-sub: build-uclibc-prelim
	make \
		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc
	make \
		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
		install
	-make \
		DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
		SYSTEM_DEVEL_PREFIX=${TOPLEV}/${TOOLROOT}/usr/i386-uclibc \
		PREFIX=${TOPLEV}/${TOOLROOT} install_target

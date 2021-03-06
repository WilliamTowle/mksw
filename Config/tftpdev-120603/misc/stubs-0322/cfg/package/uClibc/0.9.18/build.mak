#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-toolroot

build-cross: build-toolroot
	[ -d "${INSTTMP}" ]
	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
	[ -d ${INSTTMP}/uClibc-${PKGVER} ] || mkdir ${INSTTMP}/uClibc-${PKGVER}
	[ -d ${INSTTMP}/uClibc-${PKGVER}-rt ] || mkdir ${INSTTMP}/uClibc-${PKGVER}-rt
	make clean
	make defconfig
	[ -r .config.OLD ] || cp .config .config.OLD
	cat .config.OLD \
		| sed "s%/usr/src/linux%${TOOLROOT}/usr/src/linux%" \
		| sed "s%# MALLOC is not set%MALLOC=y%" \
		| sed "s%MALLOC_930716=y%# MALLOC_930716 is not set%" \
		| sed "s%UCLIBC_HAS_LFS=y%# UCLIBC_HAS_LFS is not set%" \
		| sed "s%UNIX98PTY_ONLY=y%# UNIX98PTY_ONLY is not set%" \
		| sed "s%ASSUME_DEVPTS=y%# ASSUME_DEVPTS is not set%" \
		| sed 's%SHARED_LIB_LOADER_PATH=.*%SHARED_LIB_LOADER_PATH="$(DEVEL_PREFIX)/lib"%' \
		> .config
	echo "# UCLIBC_MALLOC_DEBUGGING is not set" >> .config
#
	[ -r include/bits/uClibc_config.h.OLD ] || cp include/bits/uClibc_config.h include/bits/uClibc_config.h.OLD
	cat include/bits/uClibc_config.h.OLD \
		| sed 's/.*__UNIX98PTY_ONLY__/\/\/UNIX98PTY_ONLY: /' \
		> include/bits/uClibc_config.h
##		| sed 's/.*__UCLIBC_HAS_LFS__/\/\/UCLIBC_HAS_LFS: /' \
##		| sed "s%__KERNEL_SOURCE__.*%__KERNEL_SOURCE__ \"${TOOLROOT}/usr/src/linux/\"%" \
#
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make CROSS=${CROSS_PREFIX}- \
			DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} \
			all
	-PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
		make CROSS=${CROSS_PREFIX}- \
			DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
			SYSTEM_DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
			PREFIX=${INSTTMP}/uClibc-${PKGVER} \
			install
	-make		DEVEL_PREFIX=/usr/${CROSS_PREFIX} \
			PREFIX=${INSTTMP}/uClibc-${PKGVER}-rt \
			install_target
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr && ( \
#		mkdir -p include ;\
#		( cd include && ln -s ../${CROSS_PREFIX}/include/* ./ ) ;\
#	) || exit 1 ) || exit 1

build-toolroot:
	make clean
	make defconfig
	[ -r .config.OLD ] || cp .config .config.OLD
	cat .config.OLD \
		| sed "s%/usr/src/linux%${TOOLROOT}/usr/src/linux%" \
		| sed "s%# MALLOC is not set%MALLOC=y%" \
		| sed "s%MALLOC_930716=y%# MALLOC_930716 is not set%" \
		| sed "s%UCLIBC_HAS_LFS=y%# UCLIBC_HAS_LFS is not set%" \
		| sed "s%UNIX98PTY_ONLY=y%# UNIX98PTY_ONLY is not set%" \
		| sed "s%ASSUME_DEVPTS=y%# ASSUME_DEVPTS is not set%" \
		| sed 's%SHARED_LIB_LOADER_PATH=.*%SHARED_LIB_LOADER_PATH="$(DEVEL_PREFIX)/lib"%' \
		> .config
	echo "# UCLIBC_MALLOC_DEBUGGING is not set" >> .config
#
	[ -r include/bits/uClibc_config.h.OLD ] || cp include/bits/uClibc_config.h include/bits/uClibc_config.h.OLD
	cat include/bits/uClibc_config.h.OLD \
		| sed 's/.*__UNIX98PTY_ONLY__/\/\/UNIX98PTY_ONLY: /' \
		> include/bits/uClibc_config.h
##		| sed 's/.*__UCLIBC_HAS_LFS__/\/\/UCLIBC_HAS_LFS: /' \
##		| sed "s%__KERNEL_SOURCE__.*%__KERNEL_SOURCE__ \"${TOOLROOT}/usr/src/linux/\"%" \
#
#	PATH=${PATH} \
#	make CC=`uname -m`-pc-linux-gnu-gcc DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX}
	PATH=${PATH} \
	make CC=gcc DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX}
#	-PATH=${PATH} \
#	make CC=`uname -m`-pc-linux-gnu-gcc DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} SYSTEM_DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} install
	PATH=${PATH} \
	make CC=gcc DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} SYSTEM_DEVEL_PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} install
	make PREFIX=${TOOLROOT}/usr/${CROSS_PREFIX} install_target

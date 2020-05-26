#!/bin/gmake

include ${CONF}
include ${UNIT}

.PHONY: default

##	==
default:
	[ "${PKGNAME}" ] && [ "${PKGVER}" ]
	[ -d "${SRCXPATH}" ]
##	--
	[ "${MAKEFILE}" ] && [ "${MAKERULE}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}
##	==

.PHONY: build-cross build-toolroot

build-cross:
	[ -d ${TOOLROOT}/usr/src/linux ]
##	--
	make clean
	make defconfig
	[ -r .config.OLD ] || cp .config .config.OLD
	cat .config.OLD \
		| sed "s%/usr/src/linux%${TOOLROOT}/usr/src/linux%" \
		| sed "s%UCLIBC_HAS_LFS=y%# UCLIBC_HAS_LFS is not set%" \
		| sed "s%# MALLOC is not set%MALLOC=y%" \
		| sed "s%MALLOC_930716=y%# MALLOC_930716 is not set%" \
		| sed "s%UNIX98PTY_ONLY=y%# UNIX98PTY_ONLY is not set%" \
		| sed "s%ASSUME_DEVPTS=y%# ASSUME_DEVPTS is not set%" \
		| sed 's%SHARED_LIB_LOADER_PATH=.*%SHARED_LIB_LOADER_PATH="/lib"%' \
		> .config
	echo "# UCLIBC_MALLOC_DEBUGGING is not set" >> .config
##	--
	[ -r include/bits/uClibc_config.h.OLD ] || cp include/bits/uClibc_config.h include/bits/uClibc_config.h.OLD
	cat include/bits/uClibc_config.h.OLD \
		| sed 's/.*__UNIX98PTY_ONLY__/\/\/UNIX98PTY_ONLY: /' \
		| sed 's/.*__UCLIBC_HAS_LFS__/\/\/UCLIBC_HAS_LFS: /' \
		| sed "s%__KERNEL_SOURCE__.*%__KERNEL_SOURCE__ \"${TOOLROOT}/usr/src/linux/\"%" \
		> include/bits/uClibc_config.h
##	--
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} \
		make CROSS=${CROSS_PREFIX}- \
		 DEVEL_PREFIX=/usr/${TARGET_MACH}-linux-uclibc
	PATH=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc/bin:${PATH} \
		make CROSS=${CROSS_PREFIX}- \
		 DEVEL_PREFIX=/usr/${TARGET_MACH}-linux-uclibc \
		 SYSTEM_DEVEL_PREFIX=/usr/${TARGET_MACH}-linux-uclibc \
		 PREFIX=${INSTTMP}/uClibc-${PKGVER}-rt \
		 install_target

build-toolroot:
	[ -d ${TOOLROOT}/usr/src/linux ]
##	--
	make clean
	make defconfig
	[ -r .config.OLD ] || cp .config .config.OLD
	cat .config.OLD \
		| sed "s%/usr/src/linux%${TOOLROOT}/usr/src/linux%" \
		| sed "s%UCLIBC_HAS_LFS=y%# UCLIBC_HAS_LFS is not set%" \
		| sed "s%# MALLOC is not set%MALLOC=y%" \
		| sed "s%MALLOC_930716=y%# MALLOC_930716 is not set%" \
		| sed "s%UNIX98PTY_ONLY=y%# UNIX98PTY_ONLY is not set%" \
		| sed "s%ASSUME_DEVPTS=y%# ASSUME_DEVPTS is not set%" \
		| sed 's%SHARED_LIB_LOADER_PATH=.*%SHARED_LIB_LOADER_PATH="/lib"%' \
		> .config
	echo "# UCLIBC_MALLOC_DEBUGGING is not set" >> .config
##	--
	[ -r include/bits/uClibc_config.h.OLD ] || cp include/bits/uClibc_config.h include/bits/uClibc_config.h.OLD
	cat include/bits/uClibc_config.h.OLD \
		| sed 's/.*__UNIX98PTY_ONLY__/\/\/UNIX98PTY_ONLY: /' \
		| sed 's/.*__UCLIBC_HAS_LFS__/\/\/UCLIBC_HAS_LFS: /' \
		| sed "s%__KERNEL_SOURCE__.*%__KERNEL_SOURCE__ \"${TOOLROOT}/usr/src/linux/\"%" \
		> include/bits/uClibc_config.h
##	--
	make \
		DEVEL_PREFIX=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc
	make \
		DEVEL_PREFIX=${TOOLROOT}/usr/${TARGET_MACH}-linux-uclibc \
		install

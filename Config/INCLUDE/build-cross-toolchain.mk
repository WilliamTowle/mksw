# mksw-de configuration - build-cross-userland.mk
# last mod WmT, 2024-05-11	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BUILD_CROSS_TOOLCHAIN_MK},y)
HAVE_BUILD_CROSS_TOOLCHAIN_MK:= y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

CTI_TARGET_CPU?=i386
CTI_TARGET_LIBC?=uclibc
CTI_TARGET_SYSTYPE?=${CTI_TARGET_CPU}-mksw-linux-${CTI_TARGET_LIBC}
DIR_CTI_TOOLCHAIN?=${MF_DIR_TOP}/toolchain
PATH:=${DIR_CTI_TOOLCHAIN}/usr/bin:${PATH}


ifneq (${DIR_CTI_TOOLCHAIN},${DIR_NTI_TOOLCHAIN})
${DIR_CTI_TOOLCHAIN}:
	mkdir -p "${DIR_CTI_TOOLCHAIN}"
endif

.PHONY: cti-sanity
cti-sanity: nti-sanity ${DIR_CTI_TOOLCHAIN}


USAGE_TEXT+= "'all-cti-targets' - build all CTI (cross toolchain) targets"

.PHONY: all-cti-targets
all-cti-targets:: cti-sanity

all:: all-cti-targets


distclean::
	rm -rf "${DIR_CTI_TOOLCHAIN}"


endif	## HAVE_BUILD_CROSS_TOOLCHAIN_MK

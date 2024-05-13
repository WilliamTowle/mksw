# mksw-de configuration - build-cross-userland.mk
# last mod WmT, 2024-05-11	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BUILD_NATIVE_TOOLCHAIN_MK},y)
HAVE_BUILD_NATIVE_TOOLCHAIN_MK:= y

include ${MF_CONFIGDIR}/INCLUDE/build-native-userland.mk

DIR_NTI_TOOLCHAIN?=${MF_DIR_TOP}/toolchain
PATH:=${DIR_NTI_TOOLCHAIN}/usr/bin:${PATH}


${DIR_NTI_TOOLCHAIN}:
	mkdir -p "${DIR_NTI_TOOLCHAIN}"

.PHONY: nti-sanity
nti-sanity: config-sanity ${DIR_NTI_TOOLCHAIN}


USAGE_TEXT+= "'all-nti-targets' - build all NTI (native toolchain) targets"

.PHONY: all-nti-targets
all-nti-targets:: nti-sanity

all:: all-nti-targets


distclean::
	rm -rf "${DIR_NTI_TOOLCHAIN}"


endif	## HAVE_BUILD_NATIVE_TOOLCHAIN_MK

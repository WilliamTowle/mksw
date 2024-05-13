# mksw-de configuration - build-cross-userland.mk
# last mod WmT, 2024-05-11	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BUILD_CROSS_USERLAND_MK},y)
HAVE_BUILD_CROSS_USERLAND_MK:= y

include ${MF_CONFIGDIR}/INCLUDE/build-cross-toolchain.mk

DIR_CUI_STAGING?=${MF_DIR_TOP}/staging/target


${DIR_CUI_STAGING}:
	mkdir -p "${DIR_CUI_STAGING}"


.PHONY: cui-sanity
cui-sanity: cti-sanity ${DIR_CUI_STAGING}


USAGE_TEXT+= "'all-cui-targets' - build all CUI (cross userland) targets"

.PHONY: all-cui-targets
all-cui-targets:: cui-sanity all-cti-targets

all:: all-cui-targets


distclean::
	rm -rf "${DIR_CUI_STAGING}"


endif	## HAVE_BUILD_CROSS_USERLAND_MK
